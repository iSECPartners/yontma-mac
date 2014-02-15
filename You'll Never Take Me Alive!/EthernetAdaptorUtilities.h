//
//  EthernetAdaptorCollection.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"
#import "EthernetAdaptor.h"


@interface EthernetAdaptorUtilities : NSObject

+(Boolean) isIdentical:(NSMutableArray*)first :(NSMutableArray*)second;
+(EthernetAdaptor*) findThisAdaptor:(EthernetAdaptor*)ea InThisList:(NSMutableArray*)ethernetAdaptorList;

@end
