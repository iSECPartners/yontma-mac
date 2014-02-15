//
//  PrefWindowDelegate.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "EventLogger.h"
#import "AppState.h"

#import "MetaController.h"
#import "StartupLaunchController.h"
#import "LaptopSettingsController.h"

#import "LaptopErrorsDataSource.h"
#import "EthernetAdaptorsDataSource.h"

@interface PrefWindowController : NSWindowController <NSWindowDelegate>

//Members
@property (weak) IBOutlet NSButton *enabledCheckbox;
@property (weak) IBOutlet NSButton *runAtStartupCheckbox;
@property (weak) IBOutlet NSTextField *debuggingLogFile;

@property (weak) IBOutlet NSTextField *powerConnectedLabel;
@property (weak) IBOutlet NSTableView *ethernetAdaptorsTable;
@property (strong) EthernetAdaptorsDataSource* currentDatasource;

@property (weak) IBOutlet NSTextField *errorLabel1;
@property (weak) IBOutlet NSTextField *errorLabel2;

@property (weak) IBOutlet NSTextField *powerSettingsLabel1;
@property (weak) IBOutlet NSTextField *correctPowerSettingsQuestionLabel1;
@property (weak) IBOutlet NSButton *correctPowerSettingsButton;

@property (weak) IBOutlet NSTextField *fileVaultLabel1;
@property (weak) IBOutlet NSTextField *fileVaultLabel2;
@property (weak) IBOutlet NSButton *openSystemPreferencesButton;
@property (weak) IBOutlet NSButton *reloadErrorButton;

@property (weak) IBOutlet NSScrollView *errorTableContainer;
@property (weak) IBOutlet NSTableView *errorTable;
@property (strong) LaptopErrorsDataSource* currentErrors;


//Methods
-(IBAction) openWindowActions;

-(IBAction) toggleYontmaCheckbox:(id)sender;
-(IBAction) toggleRunAtStartupCheckbox:(id)sender;
-(IBAction) reloadButtonClick:(id)sender;
-(IBAction) openSystemPreferencesButtonClick:(id)sender;
-(IBAction) correctPowerSettingsButtonClick:(id)sender;

-(void) yontmaStatusChanged:(NSNotification *)notification;
-(void) powerStatusChanged:(NSNotification *)notification;
-(void) ethernetStatusChanged:(NSNotification*)notification;

//Overridden Methods
-(void) windowWillClose:(NSNotification *)notification;
-(id) initWithWindowNibName:(NSString *)windowNibName;
-(void) controlTextDidEndEditing:(NSNotification *)aNotification;


@end
