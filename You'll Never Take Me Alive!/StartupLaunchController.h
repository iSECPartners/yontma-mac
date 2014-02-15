//
//  StartupLaunchController.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/21/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventLogger.h"

@interface StartupLaunchController : NSObject

+(Boolean)isLaunchAtStartup;
+(void)setLaunchAtStartup:(Boolean)launchAtStartup;


@end
