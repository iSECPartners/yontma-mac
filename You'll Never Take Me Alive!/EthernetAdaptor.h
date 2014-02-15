//
//  EthernetAdaptor.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EthernetAdaptor : NSObject

//Members
@property NSString* friendlyName;
@property NSString* linuxName;
@property NSString* mac;
@property Boolean connected;

//Methods
-(id)initWithName:(NSString*)name;
-(void) printToLog;
-(Boolean) nameMatches:(EthernetAdaptor*)other;
-(Boolean) isIdenticalTo:(EthernetAdaptor*)other;


@end
