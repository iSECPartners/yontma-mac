//
//  PrefWindowDelegate.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/NSTimer.h>

#import "PrefWindowController.h"

@implementation PrefWindowController

-(id) initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yontmaStatusChanged:)
                                                 name:@"yontmaStatusChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(powerStatusChanged:)
                                                 name:@"powerStatusChanged"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ethernetStatusChanged:)
                                                 name:@"ethernetStatusChanged"
                                               object:nil];
    return self;
}

- (void)windowWillClose:(NSNotification *)notification
{
    [EventLogger Log:[NSString stringWithFormat:@"PrefWindowDelegate:windowWillClose canceling the timer:%qu.",  (unsigned long long)[AppState yontmaState].updateTimer]];
    [[AppState yontmaState] cancelUpdateTimer];
}

//==============================================================================
-(void) assignLaptopErrors:(ErrorStates)errors
{
    if(errors != NoErrors)
    {
        [self.enabledCheckbox setEnabled:false];
        [self.enabledCheckbox setState:0];
        [[AppState yontmaState] disableYontma];
        
        //General Error Labels
        [self.errorLabel1 setHidden:false];
        [self.errorLabel2 setHidden:false];
        
        //FileVault Errors
        if(errors & FileVaultError)
        {
            [[self fileVaultLabel1] setHidden:false];
            [[self fileVaultLabel2] setHidden:false];
            [[self openSystemPreferencesButton] setHidden:false];
            [[self reloadErrorButton] setHidden:false];
        }
        else
        {
            [[self fileVaultLabel1] setHidden:true];
            [[self fileVaultLabel2] setHidden:true];
            [[self openSystemPreferencesButton] setHidden:true];
            [[self reloadErrorButton] setHidden:true];
        }
        
        //Power Settings Errors
        if(errors & PowerSettingsError)
        {
            [[self powerSettingsLabel1] setHidden:false];
            [[self correctPowerSettingsQuestionLabel1] setHidden:false];
            [[self correctPowerSettingsButton] setHidden:false];
        }
        else
        {
            [[self powerSettingsLabel1] setHidden:true];
            [[self correctPowerSettingsQuestionLabel1] setHidden:true];
            [[self correctPowerSettingsButton] setHidden:true];
        }
        
        [self.errorTableContainer setHidden:false];
        [self.errorTable setHidden:false];
        self.currentErrors = [[LaptopErrorsDataSource alloc] initWithData:errors];
        [self.errorTable setDataSource:self.currentErrors];
        [self.errorTable reloadData];
    }
    else
    {
        [[AppState yontmaState] setHasFilevaultError:false];
        [[AppState yontmaState] setHasPowerSettingsError:false];
        [self.enabledCheckbox setEnabled:true];
        [self.enabledCheckbox setState:[[AppState yontmaState] yontmaEnabled] ? 1 : 0];
        
        [self.errorLabel1 setHidden:true];
        [self.errorLabel2 setHidden:true];
        
        [[self fileVaultLabel1] setHidden:true];
        [[self fileVaultLabel2] setHidden:true];
        [[self openSystemPreferencesButton] setHidden:true];
        [[self reloadErrorButton] setHidden:true];
        
        [[self powerSettingsLabel1] setHidden:true];
        [[self correctPowerSettingsQuestionLabel1] setHidden:true];
        [[self correctPowerSettingsButton] setHidden:true];
        
        [self.errorTableContainer setHidden:true];
        [self.errorTable setHidden:true];
        self.currentErrors = nil;
        [self.errorTable setDataSource:self.currentErrors];
        [self.errorTable reloadData];
    }
}
-(IBAction) toggleYontmaCheckbox:(id)sender
{
    [[AppState yontmaState] toggleYontma];
}

- (IBAction)toggleRunAtStartupCheckbox:(id)sender
{
    [[AppState yontmaState] toggleRunAtStartup];
    [self.runAtStartupCheckbox setState:[AppState yontmaState].runAtStartup ? 1 : 0];
    [StartupLaunchController setLaunchAtStartup:[AppState yontmaState].runAtStartup];
}

- (IBAction)reloadButtonClick:(id)sender
{
    ErrorStates newErrors = [LaptopSettingsController getLaptopConfigurationErrors];
    
    NSString* alertMsg;
    if(newErrors == NoErrors)
    {
        alertMsg =@"All errors resolved";
        [[AppState yontmaState] enableYontma];
    }
    else
        alertMsg =@"Some errors remain unresolved";
    
    NSAlert* msgBox = [[NSAlert alloc] init];
    [msgBox setMessageText:alertMsg];
    [msgBox addButtonWithTitle:@"OK"];
    [msgBox runModal];
    
    [self assignLaptopErrors:newErrors];
}

- (IBAction)openSystemPreferencesButtonClick:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:
     [NSURL fileURLWithPath:@"/System/Library/PreferencePanes/Security.prefPane"]];
}

- (IBAction)correctPowerSettingsButtonClick:(id)sender
{
    [CommandRunner runAsRootTask:"/usr/bin/pmset" Args:@"-a DestroyFVKeyOnStandby 1"];
    [CommandRunner runAsRootTask:"/usr/bin/pmset" Args:@"-a hibernatemode 25"];
    [CommandRunner runAsRootTask:"/usr/bin/pmset" Args:@"-a standbydelay 0"];
    [CommandRunner dropPrivileges];
    
    [self reloadButtonClick:nil];
}


-(void) controlTextDidEndEditing:(NSNotification *)aNotification
{
    NSString* debugLog = [[self debuggingLogFile] stringValue];
    if(debugLog == nil || [[debugLog stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        [[AppState yontmaState] updateLogfileName:nil];
        [[self debuggingLogFile] setBackgroundColor:[NSColor whiteColor]];
    }
    else
    {
        if([debugLog characterAtIndex:0] == '~')
            debugLog = [debugLog stringByExpandingTildeInPath];
        bool canAccess = [[NSFileManager defaultManager] createFileAtPath:debugLog contents:nil attributes:nil];
        if(canAccess)
        {
            [[AppState yontmaState] updateLogfileName:debugLog];
            [[self debuggingLogFile] setBackgroundColor:[NSColor greenColor]];
        }
        else
            [[self debuggingLogFile] setBackgroundColor:[NSColor redColor]];
    }
}
//==============================================================================
-(IBAction) openWindowActions
{
    [self yontmaStatusChanged:nil];
    [self powerStatusChanged:nil];
    [self ethernetStatusChanged:nil];
    
    [self assignLaptopErrors:[LaptopSettingsController getLaptopConfigurationErrors]];
    [self.runAtStartupCheckbox setState:[AppState yontmaState].runAtStartup ? 1 : 0];
    
    [EventLogger Log:[NSString stringWithFormat:@"PrefWindowController:windowDidLoad checking the timer:%qu.",  (unsigned long long)[AppState yontmaState].updateTimer]];
    [[AppState yontmaState] startUpdateTimer];
}
-(void) yontmaStatusChanged:(NSNotification *)notification
{
    [EventLogger Log:[NSString stringWithFormat:@"PrefWindowController recieved yontmaStatusChange Notification. New:%d", [[AppState yontmaState] yontmaEnabled]]];
    
    if([[AppState yontmaState] yontmaEnabled])
        [self.enabledCheckbox setState:1];
    else
        [self.enabledCheckbox setState:0];
}

-(void) powerStatusChanged:(NSNotification *)notification
{
    [EventLogger Log:[NSString stringWithFormat:@"PrefWindowController recieved powerStatusChanged Notification. New:%d", [[AppState yontmaState] isConnectedToACPower]]];
    
    if([[AppState yontmaState] isConnectedToACPower])
        [self.powerConnectedLabel setStringValue:@"YES"];
    else
        [self.powerConnectedLabel setStringValue:@"NO"];
}
-(void) ethernetStatusChanged:(NSNotification*)notification
{
    [EventLogger Log:[NSString stringWithFormat:@"PrefWindowController recieved ethernetStatusChanged Notification." ]];
    
    self.currentDatasource = [[EthernetAdaptorsDataSource alloc] initWithData: [[AppState yontmaState] ethernetAdaptors]];
    [self.ethernetAdaptorsTable setDataSource:self.currentDatasource];
    [self.ethernetAdaptorsTable reloadData];
}
//==============================================================================

@end
