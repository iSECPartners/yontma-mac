//
//  EventLogger.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/19/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "EventLogger.h"

@implementation EventLogger

static NSDateFormatter *dateFormatter;

static NSString* logfileName;
static NSFileHandle* logfile;

//newLog must be a valid file, otherwise we cannot handle it well (although we try to)
+(void) setLogfileName:(NSString*)newLog
{
    //One time initialization
    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/YY hh:mm:ss";
    }
    
    logfileName = newLog;
    if(newLog != nil)
    {
        logfile = [NSFileHandle fileHandleForWritingAtPath:newLog];
        if(logfile == nil)
        {
            logfileName = nil;
            [EventLogger Log:[NSString stringWithFormat:@"EventLogger:setLogfileName was given an invalid filename:%@", newLog]];
        }
        else
            [logfile seekToEndOfFile];
    }
}

+(void) Log:(NSString*)line
{
    NSLog(@"%@", line);
    if(logfileName != nil)
    {
        NSDate *now = [NSDate date];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        line = [NSString stringWithFormat:@"%@: %@\n", [dateFormatter stringFromDate:now], line];
        [logfile writeData:[line dataUsingEncoding:NSASCIIStringEncoding]];
    }
}

@end
