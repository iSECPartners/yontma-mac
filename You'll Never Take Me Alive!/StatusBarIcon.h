//
//  StatusMenu.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/15/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"
#import "AppState.h"

@interface StatusBarIconView : NSControl

@property (weak) NSStatusItem *statusBarItem;
@property (retain) NSImage *image;
@property Boolean isHighlighted;

@property (weak) id target;
@property (assign) SEL action, rightAction;

-(void) yontmaStatusChanged:(NSNotification *)notification;

-(void) showImage:(NSImage*)imageToShow;
-(void) redrawHighlight:(Boolean)shouldHighlight;

@end
