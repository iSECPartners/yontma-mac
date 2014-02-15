//
//  yontmaAppDelegate.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/15/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EventLogger.h"
#import "AppState.h"

#import "PrefWindowController.h"
#import "StatusBarIcon.h"
#import "MetaController.h"
#import "LaptopSettingsController.h"


@interface yontmaAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

//Status Bar Stuff
@property (nonatomic, strong) NSStatusItem * statusBarIcon;
@property (nonatomic, strong) StatusBarIconView *statusBarIconView;
@property (nonatomic, strong) NSMenu * statusBarMenu;

//UI Stuff
-(void) toggleYoNTMA:(id) sender;

-(void) openAboutWindow:(id) sender;
-(void) openPreferencesWindow:(id) sender;
-(void) quitYontma:(id) sender;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;


@end
