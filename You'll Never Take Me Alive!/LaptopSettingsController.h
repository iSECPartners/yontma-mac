//
//  LaptopSettingsController.h
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/19/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandRunner.h"
#import "EventLogger.h"


typedef NS_ENUM(NSInteger,  ErrorStates)
{
    NoErrors = 0,
    FileVaultError = 1,
    PowerSettingsError = 2,
    CannotStandbyError = 4
};

@interface LaptopSettingsController : NSObject

+(ErrorStates) getLaptopConfigurationErrors;

@end
