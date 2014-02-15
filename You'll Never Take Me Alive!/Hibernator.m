//
//  Hibernator.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "Hibernator.h"

#import "SystemEvents.h"

@implementation Hibernator

+ (id)hibernatorController {
    static Hibernator *hibernatorController = nil;
    @synchronized(self) {
        if (hibernatorController == nil)
            hibernatorController = [[self alloc] init];
    }
    return hibernatorController;
}

-(id) init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(somethingStatusChanged:)
                                                 name:@"powerStatusChanged"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(somethingStatusChanged:)
                                                 name:@"ethernetStatusChanged"
                                               object:nil];
    self.amIPayingAttention = false;
    
    return self;
}

-(void) setStatusOnSSInitWithPowerStatus:(Boolean)connectedToACPower AndEthernetStatus:(NSMutableArray*)ethernetAdaptorStatus
{
    //If this is called multiple times, only initialize on the first
    if(self.amIPayingAttention == false)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Hibernator:setStatusOnSSInitWithPowerStatus"]];
        
        self.amIPayingAttention = true;
        self.wasConnectedToACPowerAtScreenSaver = connectedToACPower;
        self.ethernetAdaptorStatusAtScreenSaver = ethernetAdaptorStatus;
    }
}
-(void) setStatusOnSSShutdown
{
    [EventLogger Log:[NSString stringWithFormat:@"Hibernator:setStatusOnSSShutdown"]];
    
    self.amIPayingAttention = false;
    self.wasConnectedToACPowerAtScreenSaver = false;
    self.ethernetAdaptorStatusAtScreenSaver = nil;
}

-(void) somethingStatusChanged:(NSNotification*)notification
{
    if(!self.amIPayingAttention)
        return;
    
    Boolean shouldHibernate = [self shouldHibernateFromComparisonOfPowerStatus:[[AppState yontmaState] isConnectedToACPower] AndEthernetStatus:[[AppState yontmaState] ethernetAdaptors]];
    
    [EventLogger Log:[NSString stringWithFormat:@"Hibernator:somethingStatusChanged shouldHibernate:%d yontmaEnabled:%d", shouldHibernate, [[AppState yontmaState] yontmaEnabled]]];
    
    
    if(shouldHibernate)
    {
        if(![[AppState yontmaState] yontmaEnabled])
            return;
        
        //Do Hibernate
        [EventLogger Log:@"HIBERNATING!!!"];
        [[AppState yontmaState] cancelUpdateTimer];
        [Hibernator forceHibernate];
    }
    else
    {
        [self updateStateFromNewPowerState:[[AppState yontmaState] isConnectedToACPower] AndEthernetStatus:[[AppState yontmaState] ethernetAdaptors]];
    }
}
+(void) forceHibernate
{
    NSString* output = [CommandRunner runTaskGetOutput:@"pmset sleepnow"];
    if(output.length > 0)
        [EventLogger Log:[NSString stringWithFormat:@"Hibernator:forceHibernate had output: %@", output]];
    
    return;
}

-(Boolean) shouldHibernateFromComparisonOfPowerStatus:(Boolean)connectedToACPower AndEthernetStatus:(NSMutableArray*)ethernetAdaptorStatus
{
    if(self.wasConnectedToACPowerAtScreenSaver == true && connectedToACPower == false)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Hibernator:shouldHibernateFromComparisonOfPowerStatus AC triggered Hiberation Flag"]];
        return true;
    }
    for(EthernetAdaptor* ea in self.ethernetAdaptorStatusAtScreenSaver)
    {
        if(ea.connected)
        {
            EthernetAdaptor* oa = [EthernetAdaptorUtilities findThisAdaptor:ea InThisList:ethernetAdaptorStatus];
            if(oa == nil)
            {
                [EventLogger Log:[NSString stringWithFormat:@"Hibernator:shouldHibernateFromComparisonOfPowerStatus missing Ethernet Adaptor (%@ - %@) triggered Hiberation Flag", ea.friendlyName, ea.linuxName]];
                return true;
            }
            else if(!oa.connected)
            {
                [EventLogger Log:[NSString stringWithFormat:@"Hibernator:shouldHibernateFromComparisonOfPowerStatus present (but unconnected) Ethernet Adaptor (%@ - %@) triggered Hiberation Flag", ea.friendlyName, ea.linuxName]];
                return true;
            }
        }
    }
    
    return false;
}

-(void) updateStateFromNewPowerState:(Boolean)connectedToACPower AndEthernetStatus:(NSMutableArray*)ethernetAdaptorStatus
{
    if(self.wasConnectedToACPowerAtScreenSaver == false && connectedToACPower == true)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Hibernator:updateStateFromNewPowerState AC is updated during hibernation"]];
        self.wasConnectedToACPowerAtScreenSaver = true;
    }
    
    for(EthernetAdaptor* oa in ethernetAdaptorStatus)
    {
        if(oa.connected)
        {
            EthernetAdaptor* ea = [EthernetAdaptorUtilities findThisAdaptor:oa InThisList:self.ethernetAdaptorStatusAtScreenSaver];
            
            //Conundrum: do we update the ist of EAs we have, or do we replace it?
            //If we replace, we may be overwriting state from a different adaptor
            //If we update, we will miss an adaptor was that was unplugged
            //But actually, if we're in this code path, we know we shouldn't be hibernating
            //  Which means no adaptor that was connected is now unplugged
            //  So it's safe to overwrite the state, because it can only be an addition
            //      of connected adaptors - never a subtraction
            if(ea == nil)
            {
                [EventLogger Log:[NSString stringWithFormat:@"Hibernator:updateStateFromNewPowerState Ethernet Adaptor (%@ - %@) was missing earlier, but now is connected during hibernation", ea.friendlyName, ea.linuxName]];
                self.ethernetAdaptorStatusAtScreenSaver = ethernetAdaptorStatus;
                return;
            }
            else if(!ea.connected)
            {
                [EventLogger Log:[NSString stringWithFormat:@"Hibernator:updateStateFromNewPowerState Ethernet Adaptor (%@ - %@) was present earlier, but now is connected during hibernation", ea.friendlyName, ea.linuxName]];
                self.ethernetAdaptorStatusAtScreenSaver = ethernetAdaptorStatus;
                return;
            }
        }
    }
}

@end
