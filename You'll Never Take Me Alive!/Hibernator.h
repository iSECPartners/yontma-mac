//
//  Hibernator.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"

#import "AppState.h"
#import "EthernetAdaptor.h"
#import "EthernetAdaptorUtilities.h"
#import "CommandRunner.h"

@interface Hibernator : NSObject

//Singleton
+ (id)hibernatorController;

//Members
@property Boolean amIPayingAttention;
@property Boolean wasConnectedToACPowerAtScreenSaver;
@property NSMutableArray* ethernetAdaptorStatusAtScreenSaver;

//Methods
-(void) setStatusOnSSShutdown;
-(void) setStatusOnSSInitWithPowerStatus:(Boolean)connectedToACPower AndEthernetStatus:(NSMutableArray*)ethernetAdaptorStatus;

-(Boolean) shouldHibernateFromComparisonOfPowerStatus:(Boolean)connectedToACPower AndEthernetStatus:(NSMutableArray*)ethernetAdaptorStatus;


@end
