//
//  EthernetAdaptorsDataSource.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "EthernetAdaptorsDataSource.h"

@implementation EthernetAdaptorsDataSource

- (id) initWithData:(NSMutableArray*)data
{
    self = [super init];
    
    self.ethernetAdaptors = [data copy];

    return self;
}



- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    int c = (int)[self.ethernetAdaptors count];
    return c;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    NSString* col = [tableColumn identifier];
    EthernetAdaptor *ea = [self.ethernetAdaptors objectAtIndex:row];
    
    if([col  isEqual: @"FriendlyName"])
        return [ea friendlyName];
    if([col  isEqual: @"LinuxName"])
        return [ea linuxName];
    if([col  isEqual: @"MAC"])
        return [ea mac];
    if([col  isEqual: @"Connected"])
        return [ea connected] ? @"Yes" : @"No";
    return @"";
}

@end
