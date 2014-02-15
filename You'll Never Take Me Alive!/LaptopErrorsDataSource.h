//
//  LaptopErrorsDataSource.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/19/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaptopSettingsController.h"

@interface LaptopErrorsDataSource : NSObject <NSTableViewDataSource>

@property ErrorStates errors;

- (id) initWithData:(ErrorStates)data;

- (int)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
@end
