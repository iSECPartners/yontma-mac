//
//  StatusMenu.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/15/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "StatusBarIcon.h"

@implementation StatusBarIconView

- (id) init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(yontmaStatusChanged:)
        name:@"yontmaStatusChanged"
        object:nil];
    
    return self;
}

- (void)mouseUp:(NSEvent *)event {
    if([event modifierFlags] & NSControlKeyMask)
    {
        [NSApp sendAction:self.rightAction to:self.target from:self];
    } else {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)rightMouseUp:(NSEvent *)event
{
    [NSApp sendAction:self.rightAction to:self.target from:self];
}

- (void)drawRect:(NSRect)rect
{
    [self.statusBarItem drawStatusBarBackgroundInRect:rect withHighlight:self.isHighlighted];
    [self.image drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

-(void) showImage:(NSImage*)imageToShow
{
    self.image = imageToShow;
    [self setNeedsDisplay:true];
}
-(void) redrawHighlight:(Boolean)shouldHighlight
{
    self.isHighlighted = shouldHighlight;
    [self setNeedsDisplay:true];
}

-(void) yontmaStatusChanged:(NSNotification *)notification
{
    [EventLogger Log:[NSString stringWithFormat:@"StatusBarIconView recieved yontmaStatusChange Notification. New:%d", [[AppState yontmaState] yontmaEnabled]]];

    if([[AppState yontmaState] yontmaEnabled])
        [self showImage:[NSImage imageNamed:@"StatusEnabled"]];
    else
        [self showImage:[NSImage imageNamed:@"StatusDisabled"]];

}

@end
