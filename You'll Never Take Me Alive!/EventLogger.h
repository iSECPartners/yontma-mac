//
//  EventLogger.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/19/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppState.h"

@interface EventLogger : NSObject

+(void) Log:(NSString*)line;

+(void) setLogfileName:(NSString*)newLog;

@end
