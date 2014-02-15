//
//  EthernetAdaptor.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "EthernetAdaptor.h"

@implementation EthernetAdaptor

-(id)initWithName:(NSString*)friendlyName
{
    self = [super init];

    self.friendlyName = [friendlyName copy];
    self.linuxName = nil;
    self.mac = nil;
    self.connected = false;
    
    return self;
}

-(void)printToLog
{
    NSLog(@"%@", self.friendlyName);
    NSLog(@"\tMac: %@", self.mac);
    NSLog(@"\tLinux Name: %@", self.linuxName);
    NSLog(@"\tConnected: %@", self.connected ? @"YES" : @"NO");
}

-(Boolean) nameMatches:(EthernetAdaptor*)other
{
    if(! [self.friendlyName isEqual: [other friendlyName]])
        return false;
    
    if(self.linuxName == nil && [other linuxName] == nil)
        ;
    else if(self.linuxName != nil && ![self.linuxName isEqual: [other linuxName]])
        return false;
    else if(self.linuxName == nil && [other linuxName] != nil)
        return false;
    
    if(self.mac == nil && [other mac] == nil)
        ;
    else if(self.mac != nil && ![self.mac isEqual: [other mac]])
        return false;
    else if(self.mac == nil && [other mac] != nil)
        return false;
    
    return true;
}
-(Boolean) isIdenticalTo:(EthernetAdaptor*)other
{
    if(![self nameMatches:other])
        return false;
    
    if(self.connected != [other connected])
        return false;
    
    return true;
}

@end
