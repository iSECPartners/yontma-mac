//
//  MetaController.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogger.h"
#import "AppState.h"

#import "PowerController.h"
#import "EthernetController.h"

#import "ScreenSaverController.h"
#import "LaptopSettingsController.h"

#import "StartupLaunchController.h"
#import "Hibernator.h"

#import "EthernetAdaptorUtilities.h"


@interface MetaController : NSObject

+(void) initYontmaState;
+(void) detectChanges;

@end
