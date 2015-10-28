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
    
    if(![LaptopSettingsController canStandby])
        errors |= CannotStandbyError;
    
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

+(Boolean) canStandby
{
    NSString* output = [CommandRunner runTaskGetOutput:@"sysctl hw.model"];
    
    NSString* model;
    NSInteger i;
    NSInteger majorVersion;
    NSInteger minorVersion;
    Boolean isRetina;
    
    NSArray *split = [output componentsSeparatedByString:@","];
    if([split count] != 2)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Got strange un-splitable model: %@", output]];
        return false;
    }
    
    //We're using the model variable as a temp here
    model = [split objectAtIndex:1];
    //Grab the minor version after the comma
    minorVersion = [model integerValue];
    
    //Now make model the value left of the comma
    model = [split objectAtIndex:0];
    //Find the first non-digit from the back
    i =[model length]-1;
    while([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[model characterAtIndex:i]])
        i--;
    //Put that into model temprarily
    model = [model substringFromIndex:i+1];
    //And convert it to int
    majorVersion = [model integerValue];

    //Now start again and assign the model correctly
    model = [split objectAtIndex:0];
    model = [model substringToIndex:i+1];

    isRetina = [[NSScreen mainScreen] backingScaleFactor] == 2.0f;

    //From http://support.apple.com/kb/ht4392 and http://www.everymac.com/systems/by_capability/mac-specs-by-machine-model-machine-id.html
    if([model rangeOfString:@"MacBookPro"].location != NSNotFound)
    {
        //MacBook Pro (Retina, Mid 2012)
        if(majorVersion == 10 && isRetina)
            return true;
        
        //Seems redundant
        //MacBook Pro (Retina, 15-inch, Early 2013) and later
        //if(majorVersion == 10 && minorVersion == 1 && is15Inch && isRetina)
        //    return true;
        //MacBook Pro (Retina, 13-inch, Late 2012) and later
        //if(majorVersion == 10 && minorVersion == 2 && is13Inch && isRetina)
        //    return true;
        //'and later'
        if(majorVersion >= 11)
            return true;
        
        return false;
    }
    else if([model rangeOfString:@"MacBookAir"].location != NSNotFound)
    {
        //MacBook Air (Mid 2010) and later
        if(majorVersion >= 3)
            return true;
        return false;
    }
    else if([model rangeOfString:@"MacBook"].location != NSNotFound)
    {
        //MacBook (2015) and later
        if(majorVersion >= 8)
            return true;
        return false;
    }
    else
        return false;
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
