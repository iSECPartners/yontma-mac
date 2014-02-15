//
//  EthernetAdaptorsDataSource.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"
#import "EthernetAdaptor.h"

@interface EthernetAdaptorsDataSource : NSObject <NSTableViewDataSource>

@property (strong) NSMutableArray* ethernetAdaptors;

- (id) initWithData:(NSMutableArray*)data;

- (int)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
@end
