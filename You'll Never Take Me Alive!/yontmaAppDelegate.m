//
//  yontmaAppDelegate.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/15/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "yontmaAppDelegate.h"

#define STATUS_ITEM_VIEW_WIDTH 24.0

@implementation yontmaAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Initialize State ==============================================
    [MetaController  initYontmaState];
    
    // Set Up Status Bar Menu ========================================
    self.statusBarMenu = [[NSMenu alloc] init];
    [self.statusBarMenu insertItemWithTitle:@"Preferences" action:@selector(openPreferencesWindow:) keyEquivalent:@"" atIndex:0];
    [self.statusBarMenu insertItemWithTitle:@"About YoNTMA" action:@selector(openAboutWindow:) keyEquivalent:@"" atIndex:1];
    [self.statusBarMenu insertItem:[NSMenuItem separatorItem] atIndex:2];
    [self.statusBarMenu insertItemWithTitle:@"Quit" action:@selector(quitYontma:) keyEquivalent:@"" atIndex:3];
    [self.statusBarMenu setDelegate:self];
    
    // Set Up Status Bar Icon ========================================
    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];
    
    self.statusBarIcon = [systemStatusBar statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    
    self.statusBarIconView = [StatusBarIconView new];
    self.statusBarIconView.target = self;
    self.statusBarIconView.action = @selector(toggleYoNTMA:);
    self.statusBarIconView.rightAction = @selector(openYoNTMAMenu:);
    self.statusBarIconView.statusBarItem = self.statusBarIcon;
    [self.statusBarIconView showImage:[NSImage imageNamed:@"StatusEnabled"]];
    
    [self.statusBarIcon setView:self.statusBarIconView];
    [self.statusBarIcon setToolTip:@"You'll Never Take Me Alive!"];
    
    [EventLogger Log:[NSString stringWithFormat:@"yontmaAppDelegate:applicationDidFinishLaunching Completed"]];
    
    if([[AppState yontmaState] hasErrors])
    {
        [[AppState yontmaState] disableYontma];
        [self openPreferencesWindow:nil];
    }
}

- (void)menuDidClose:(NSMenu *)menu
{
    if(menu == self.statusBarMenu)
    {
        [self.statusBarIconView redrawHighlight:false];
    }
}

-(void)toggleYoNTMA:(id) sender
{
    [[AppState yontmaState] toggleYontma];
    if([[AppState yontmaState] yontmaEnabled] && [[AppState yontmaState] hasErrors])
        [[AppState yontmaState] disableYontma];
}

-(void) openYoNTMAMenu:(id) sender
{
    [self.statusBarIconView redrawHighlight :true];
    [self.statusBarIcon popUpStatusItemMenu: self.statusBarMenu];
}

-(void) openAboutWindow:(id) sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:true];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

-(void) openPreferencesWindow:(id) sender
{
    static PrefWindowController* prefWindow = nil;

    if(!prefWindow)
    {
        prefWindow = [[PrefWindowController alloc] initWithWindowNibName:@"Preferences"];
        [prefWindow showWindow:self];
        [prefWindow openWindowActions];
    }
    else
    {
        if([[prefWindow window] isVisible])
            ;
        else
        {
            [prefWindow showWindow:self];
            [prefWindow openWindowActions];
        }
    }
    //Always bring it to the top
    [[NSApplication sharedApplication] activateIgnoringOtherApps:true];
}

-(void) quitYontma:(id) sender
{
    [[AppState yontmaState] cancelUpdateTimer];
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}


@end
