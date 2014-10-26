//
//  AppState.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"

//Needed so we can give a function pointer on the updateTimer
#import "MetaController.h"

//Seconds between timer polls
#define TIMER_POLL_INTERVAL 1

@interface AppState : NSObject

//Singleton
+ (AppState*) yontmaState;

//Members
//Non-nil when we have a timer going for updating things
@property NSTimer* updateTimer;

@property Boolean yontmaEnabled;
@property Boolean runAtStartup;

@property Boolean hasFilevaultError;
@property Boolean hasPowerSettingsError;
@property Boolean cannotStandby;
-(Boolean) hasErrors;

@property NSString* logfileName;

@property Boolean isConnectedToACPower;
@property NSMutableArray* ethernetAdaptors;

//Methods
-(void) enableYontma;
-(void) disableYontma;
-(void) toggleYontma;

-(void) toggleRunAtStartup;

-(void) startUpdateTimer;
-(void) cancelUpdateTimer;

-(void)updateLogfileName:(NSString*)debugLog;


@end
