//
//  LaptopSettingsController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/19/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "LaptopSettingsController.h"

@implementation LaptopSettingsController

+(ErrorStates) getLaptopConfigurationErrors
{
    ErrorStates errors = NoErrors;
    
    if([LaptopSettingsController hasWrongPMHibernateValue])
        errors |= PowerSettingsError;

    if([LaptopSettingsController hasWrongFileVaultSecurity])
        errors |= PowerSettingsError;
    
    if([LaptopSettingsController hasWrongStandbyDelay])
        errors |= PowerSettingsError;
    
    if(![LaptopSettingsController hasFileVault])
        errors |= FileVaultError;
    
    return errors;
}

+(Boolean) hasFileVault
{
    NSString* output = [CommandRunner runTaskGetOutput:@"fdesetup status"];
    if([output isEqualToString:@"FileVault is On.\n"])
        return true;
    return false;
}

+(Boolean) hasWrongPMHibernateValue
{
    NSString* output = [CommandRunner runTaskGetOutput:@"pmset -g custom | grep hibernatemode"];
    if([output isEqualToString:@" hibernatemode        25\n hibernatemode        25\n"])
        return false;
    return true;
}

+(Boolean) hasWrongFileVaultSecurity
{
    NSString* output = [CommandRunner runTaskGetOutput:@"pmset -g | grep DestroyFVKeyOnStandby"];
    if([output isEqualToString:@" DestroyFVKeyOnStandby		1\n"])
        return false;
    return true;
}

+(Boolean) hasWrongStandbyDelay
{
    NSString* output = [CommandRunner runTaskGetOutput:@"pmset -g | grep standbydelay"];
    if([output isEqualToString:@" standbydelay         0\n"])
        return false;
    return true;
}

@end
