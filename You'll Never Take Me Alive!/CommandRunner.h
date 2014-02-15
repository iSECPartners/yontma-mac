//
//  CommandRunner.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/20/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventLogger.h"

@interface CommandRunner : NSObject

+(NSString*) runTaskGetOutput:(NSString*)cmd;
+(void) runAsRootTask:(char*)cmd Args:(NSString*)args;
+(void) dropPrivileges;

@end
