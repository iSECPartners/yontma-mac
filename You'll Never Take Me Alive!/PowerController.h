//
//  PowerController.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import "EventLogger.h"

@interface PowerController : NSObject

+(Boolean) isAttachedToPower;

@end
