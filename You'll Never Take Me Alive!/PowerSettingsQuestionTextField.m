//
//  PowerSettingsQuestionDelegate.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/20/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "PowerSettingsQuestionTextField.h"

@implementation PowerSettingsQuestionTextField

-(void)mouseDown:(NSEvent *)event
{
    NSString* msg = @"The following commands will be run when you click 'Correct':\n\n\
sudo pmset -a DestroyFVKeyOnStandby 1\n\
sudo pmset -a hibernatemode 25\n\
sudo pmset -a standbydelay 0\n\n\
\
If you're extra-paranoid, feel free to run them yourself and restart YoNTMA";

    
    NSAlert* msgBox = [[NSAlert alloc] init];
    [msgBox setMessageText:msg];
    [msgBox addButtonWithTitle:@"OK"];
    [msgBox runModal];
}

- (void)resetCursorRects
{
    [self addCursorRect:[self bounds] cursor: [NSCursor pointingHandCursor]];
}

@end
