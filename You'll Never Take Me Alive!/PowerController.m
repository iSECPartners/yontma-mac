//
//  PowerController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/17/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "PowerController.h"

@implementation PowerController

+(Boolean) isAttachedToPower
{
    Boolean result;
    CFDictionaryRef details = IOPSCopyExternalPowerAdapterDetails();
    if(details == nil)
        result =  false;
    else
    {
        result = true;
        CFRelease(details);
    }
    return result;
}

@end
