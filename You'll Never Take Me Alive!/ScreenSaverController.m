//
//  ScreenSaverController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "ScreenSaverController.h"

@implementation ScreenSaverController

+ (id)screensaverController {
    static ScreenSaverController *screensaverController = nil;
    @synchronized(self) {
        if (screensaverController == nil)
            screensaverController = [[self alloc] init];
    }
    return screensaverController;
}

-(id) init {
    NSDistributedNotificationCenter * center
    = [NSDistributedNotificationCenter defaultCenter];
    
    [center addObserver: self
               selector:    @selector(screensaverStarted:)
                   name:        @"com.apple.screensaver.didstart"
                 object:      nil
     ];
    [center addObserver: self
               selector:    @selector(screensaverStopped:)
                   name:        @"com.apple.screensaver.didstop"
                 object:      nil
     ];
    [center addObserver: self
               selector:    @selector(screensaverStarted:)
                   name:        @"com.apple.screenIsLocked"
                 object:      nil
     ];
    [center addObserver: self
               selector:    @selector(screensaverStopped:)
                   name:        @"com.apple.screenIsUnlocked"
                 object:      nil
     ];

    return self;
}

-(void) screensaverStarted: (NSNotification*) notification
{
    //In these event this is called multiple times per ScreenSaver (which it will) nothing should cause problems
    [EventLogger Log:[NSString stringWithFormat:@"ScreensaverController:screensaverStarted"]];
    [MetaController detectChanges];
    [[Hibernator hibernatorController] setStatusOnSSInitWithPowerStatus:[[AppState yontmaState] isConnectedToACPower] AndEthernetStatus:[[AppState yontmaState] ethernetAdaptors]];
    [[AppState yontmaState] startUpdateTimer];

    
}
-(void) screensaverStopped: (NSNotification*) notification
{
    [EventLogger Log:[NSString stringWithFormat:@"ScreensaverController:screensaverStopped"]];
    [MetaController detectChanges];
    [[Hibernator hibernatorController] setStatusOnSSShutdown];
    [[AppState yontmaState] cancelUpdateTimer];

}
@end

