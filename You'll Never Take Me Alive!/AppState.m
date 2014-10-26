//
//  AppState.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "AppState.h"

@implementation AppState

+ (id)yontmaState
{
    static AppState *yontmaState = nil;
    @synchronized(self) {
        if (yontmaState == nil)
            yontmaState = [[AppState alloc] init];
    }
    return yontmaState;
}

-(id) init
{
    self.yontmaEnabled = true;
    self.logfileName = @"~/yontmaLog.txt";
    
    return self;
}

-(Boolean) hasErrors
{
    return self.hasFilevaultError || self.hasPowerSettingsError || self.cannotStandby;
}


//==============================================================================
-(void) enableYontma
{
    [EventLogger Log:[NSString stringWithFormat:@"AppState:enableYontma Posting yontmaStatusChanged Notification. Old: %d New:%d", self.yontmaEnabled, true]];
    
    if(self.yontmaEnabled) return;
    
    
    self.yontmaEnabled = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yontmaStatusChanged" object:self];
}
-(void) disableYontma
{
    [EventLogger Log:[NSString stringWithFormat:@"AppState:disableYontma Posting yontmaStatusChanged Notification. Old: %d New:%d", self.yontmaEnabled, false]];

    if(!self.yontmaEnabled) return;
    
    self.yontmaEnabled = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yontmaStatusChanged" object:self];
}
-(void) toggleYontma
{
    [EventLogger Log:[NSString stringWithFormat:@"AppState:toggleYontma Posting yontmaStatusChanged Notification. Old: %d New:%d", self.yontmaEnabled, !self.yontmaEnabled]];

    self.yontmaEnabled = !self.yontmaEnabled;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yontmaStatusChanged" object:self];
}
//==============================================================================
-(void) toggleRunAtStartup
{
    self.runAtStartup = !self.runAtStartup;
}
-(void)updateLogfileName:(NSString*)debugLog
{
    self.logfileName = debugLog;
    [EventLogger setLogfileName:debugLog];
}
//==============================================================================
-(void) startUpdateTimer
{
    if([[AppState yontmaState] updateTimer] == nil)
    {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_POLL_INTERVAL target:[MetaController class] selector:@selector(detectChanges) userInfo:nil repeats:true];
        [[AppState yontmaState] setUpdateTimer:timer];
        [EventLogger Log:[NSString stringWithFormat:@"AppState:startUpdateTimer set the timer:%qu.",  (unsigned long long)[AppState yontmaState].updateTimer]];
    }
}
-(void) cancelUpdateTimer
{
    if([[AppState yontmaState] updateTimer] != nil)
    {
        [[AppState yontmaState].updateTimer invalidate];
        [AppState yontmaState].updateTimer = nil;
        [EventLogger Log:[NSString stringWithFormat:@"AppState:cancelUpdateTimer set the timer:%qu.",  (unsigned long long)[AppState yontmaState].updateTimer]];
    }
}



@end
