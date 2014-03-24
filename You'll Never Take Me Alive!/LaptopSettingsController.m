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
    SInt32 versMin;
    Gestalt(gestaltSystemVersionMinor, &versMin);
    if(versMin >= 9)//fdesetup requires root on 10.8
    {
        NSString* output = [CommandRunner runTaskGetOutput:@"fdesetup status"];
        if([output rangeOfString:@"FileVault is On"].location != NSNotFound)
            return true;
        return false;
    }
    else
    {
        NSString* output = [CommandRunner runTaskGetOutput:@"diskutil cs list"];
        if([output rangeOfString:@"Encryption Type:         AES-XTS"].location != NSNotFound)
            return true;
        return false;
    }
}

+(Boolean) hasWrongPMHibernateValue
{
    NSString* output = [CommandRunner runTaskGetOutput:@"pmset -g | grep hibernatemode"];
    if([output rangeOfString:@" hibernatemode        25\n"].location != NSNotFound)
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
