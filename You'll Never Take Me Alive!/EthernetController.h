//
//  EthernetController.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkConfiguration.h>
#import <SystemConfiguration/SCNetworkConnection.h>
#import "EventLogger.h"

#import "EthernetAdaptor.h"


@interface EthernetController : NSObject

+(NSMutableArray*) getInterfaces;

@end
