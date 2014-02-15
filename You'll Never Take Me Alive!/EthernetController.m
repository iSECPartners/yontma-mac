//
//  EthernetController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "EthernetController.h"
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <netdb.h>
#include <net/if.h>
#include <netinet/in.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation EthernetController

/*
 MAC Air w/ Thunderbolt Bridge Adaptor
 - If the Adaptor has not been plugged in since boot, it will not show up in the list of interfaces from SCNetworkServiceCopyAll
 - If the adaptor has been plugged in since boot, but is not presently plugged in, you will not be able to retrieve it's MAC address from SCNetworkInterfaceGetHardwareAddressString
 - If the adaptor is plugged in but no (live) cable is plugged into it, the ifa_addr->sa_family will only be AF_LINK
 - If the adaptor is plugged in and a dead cable is plugged into it (e.g. the other end is not attached to anything) it behaves the same
 - If the adaptor is plugged in and it is live, it will have AF_INET and/or AF_INET6
 - If the adaptor is plugged in and the cable is powered but no response, I believe you'll get a 169 address and it will behave the same (which is good)
 
 */


+(NSMutableArray*) getInterfaces
{
    //For storing interfaces I see.
    //  If it has a MAC, then it can continue to Linux Name resolution and then connection checking
    //  If it doesn't, then it may get a MAC eventually, so I want to inform the user of it, but it won't factor into connection checking
    NSMutableArray *potentialPhysicalEthernets = [[NSMutableArray alloc] init];
    
    //--------------------------------------------------------------------------
    //First Identify the Physical Interfaces -----------------------------------
    SCPreferencesRef preferences = SCPreferencesCreate(kCFAllocatorDefault, CFSTR("PRG"), NULL);
    CFArrayRef serviceArray = SCNetworkServiceCopyAll(preferences);
    for (int i=0; i < CFArrayGetCount(serviceArray); i++) {
        SCNetworkServiceRef networkServiceRef = (SCNetworkServiceRef)CFArrayGetValueAtIndex(serviceArray, i);
        SCNetworkInterfaceRef curIf = (SCNetworkInterfaceRef)SCNetworkServiceGetInterface(networkServiceRef);
        NSString *serviceName = (__bridge NSString *)SCNetworkServiceGetName(networkServiceRef);
        
        if([EthernetController isPhysicalEthernetPort:serviceName :curIf])
        {
            EthernetAdaptor *thisAdaptor = [[EthernetAdaptor alloc] initWithName:serviceName];
            //NSLog(@"Found %s - %@\n", [(__bridge NSString*) SCNetworkInterfaceGetInterfaceType(curIf) UTF8String], serviceName);
            
            NSString* mac = [(__bridge NSString*) SCNetworkInterfaceGetHardwareAddressString(curIf) copy];
            //The MAC is not always available - if it's a Thunderbolt Ethernet Bridge that is not connected, the MAC will be nil
            if(mac != nil)
                thisAdaptor.mac = mac;
            
            [potentialPhysicalEthernets addObject:thisAdaptor];
        }
        //Leave around for debugging
        //else
        //{
        //    NSLog(@"Neagtive %s - %s\n", [(__bridge NSString*) SCNetworkInterfaceGetInterfaceType(curIf) UTF8String], [serviceName UTF8String]);
        //    NSLog(@"   %s\n", [(__bridge NSString*) SCNetworkInterfaceGetHardwareAddressString(curIf) UTF8String]);
        //}
        //if(SCNetworkInterfaceGetInterface(curIf) != NULL)
        //    NSLog(@"   Not a leaf");
    }
    
    //--------------------------------------------------------------------------
    //Then Figure out if they're connected -------------------------------------
    struct ifaddrs* interfaces = NULL;
    struct ifaddrs* temp_if = NULL;
    //Retrieve the current interfaces - returns 0 on success
    NSInteger success = getifaddrs(&interfaces);
    if (success == 0)
    {
        //Loop through the first time matching MACs with Names
        temp_if = interfaces;
        while (temp_if != NULL)
        {
            NSString* name = [NSString stringWithUTF8String:temp_if->ifa_name];
            
            if(!(temp_if->ifa_flags & IFF_LOOPBACK) && temp_if->ifa_addr->sa_family == AF_LINK)
            {
                //NSLog(@"interface name: %@", name);
                //NSLog(@"   address family: %d (AF_LINK)", temp_addr->ifa_addr->sa_family);
                
                uint8_t* MAC = LLADDR((struct sockaddr_dl*)temp_if->ifa_addr);
                NSString* mac = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", MAC[0], MAC[1], MAC[2], MAC[3], MAC[4], MAC[5]];
                
                [EthernetController updateAdaptorList:potentialPhysicalEthernets WithThisMAC:mac ToLinuxName:name];
            }
            temp_if = temp_if->ifa_next;
        }
        
        //Loop through the second time getting the matched names' connection status
        temp_if = interfaces;
        while (temp_if != NULL)
        {
            int family = temp_if->ifa_addr->sa_family;
            if(!(temp_if->ifa_flags & IFF_LOOPBACK) && (family == AF_INET || family == AF_INET6))
            {
                NSString* name = [NSString stringWithUTF8String:temp_if->ifa_name];
                if([EthernetController doesThisAdaptorList:potentialPhysicalEthernets ContainThisLinuxName:name])
                    if([EthernetController isConnectedInterface:temp_if])
                        [EthernetController updateAdaptorList:potentialPhysicalEthernets withThisLinuxName:name ToStatus:true];
            }
            temp_if = temp_if->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    CFRelease(serviceArray);
    
    //for(EthernetAdaptor* adaptor in potentialPhysicalEthernets)
    //    [adaptor printToLog];
    
    return potentialPhysicalEthernets;
}

//==============================================================================
//Business Logic Functions =====================================================
+(Boolean) isPhysicalEthernetPort:(NSString*)interfaceName :(SCNetworkInterfaceRef)interfaceReference
{
    CFStringRef ifType = SCNetworkInterfaceGetInterfaceType(interfaceReference);
    if(ifType == kSCNetworkInterfaceTypeEthernet)
    {
        if(strstr([interfaceName cStringUsingEncoding:(NSUTF8StringEncoding)], "Bluetooth") != NULL)
            return false;
        return true;
    }
    return false;
}

+(Boolean) isConnectedInterface:(struct ifaddrs*)interface
{
    int family = interface->ifa_addr->sa_family;
    
    if(!(interface->ifa_flags & IFF_UP))
        return 0;
    if(!(interface->ifa_flags & IFF_RUNNING))
        return 0;
    
    int retVal;
    char host[NI_MAXHOST];
    if(family == AF_INET)
    {
        retVal = getnameinfo(interface->ifa_addr, sizeof(struct sockaddr_in),
                             host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
    }
    else if(family == AF_INET6)
    {
        retVal = getnameinfo(interface->ifa_addr, sizeof(struct sockaddr_in6),
                             host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
    }
    else
    {
        [EventLogger Log:[NSString stringWithFormat:@"In isConnectedInterface and we got an unexpected family value: %d", family]];
        retVal = 1;
    }
    if (retVal != 0) {
        //Failure Getting Address
        return 0;
    }
    
    //If nothing went wrong, assume it's up
    return 1;
}

//==============================================================================
//Dinky Helper Functions =======================================================
+(void) updateAdaptorList:(NSMutableArray*)list WithThisMAC:(NSString*)mac ToLinuxName:(NSString*)name
{
    for(EthernetAdaptor* adaptor in list)
    {
        if([adaptor.mac isEqual: mac])
            adaptor.linuxName = name;
    }
}
+(void) updateAdaptorList:(NSMutableArray*)list withThisLinuxName:(NSString*)name ToStatus:(Boolean)status
{
    for(EthernetAdaptor* adaptor in list)
    {
        if([adaptor.linuxName isEqual: name])
            adaptor.connected = status;
    }
}
+(Boolean) doesThisAdaptorList:(NSMutableArray*)list ContainThisLinuxName:(NSString*)name
{
    for(EthernetAdaptor* adaptor in list)
    {
        if([adaptor.linuxName isEqual: name])
            return true;
    }
    return false;
}
@end
