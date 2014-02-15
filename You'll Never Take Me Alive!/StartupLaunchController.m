//
//  StartupLaunchController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/21/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "StartupLaunchController.h"

@implementation StartupLaunchController

+(Boolean)isLaunchAtStartup
{
    // See if the app is currently in LoginItems.
    LSSharedFileListItemRef itemRef = [StartupLaunchController itemRefInLoginItems];
    // Store away that boolean.
    BOOL isInList = itemRef != nil;
    // Release the reference if it exists.
    if (itemRef != nil) CFRelease(itemRef);
    
    return isInList;
}

+ (void)setLaunchAtStartup:(Boolean)launchAtStartup
{
    [EventLogger Log:[NSString stringWithFormat:@"StartupLaunchController:setLaunchAtStartup Setting Launch At Startup: %d", launchAtStartup]];
    
    // See if the app is currently in LoginItems.
    LSSharedFileListRef loginItemsRef = nil;
    LSSharedFileListItemRef itemRef = [StartupLaunchController itemRefInLoginItems];
    
    if(itemRef == nil && !launchAtStartup)
        //Don't launch and we're currently not - good
        goto cleanup;
    else if(itemRef != nil && launchAtStartup)
        //Launch and we currently are - good
        goto cleanup;
    
    // Get the LoginItems list.
    loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Error in setLaunchAtStartup, LSSharedFileListCreate failed"]];
        goto cleanup;
    }
    if (launchAtStartup)
    {// Add the app to the LoginItems list.
        [EventLogger Log:[NSString stringWithFormat:@"StartupLaunchController:setLaunchAtStartup Enabling Launch At Startup"]];

        CFURLRef appUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        
        LSSharedFileListItemRef appAdded = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
        if (appAdded) CFRelease(appAdded);
        else
        {
            [EventLogger Log:[NSString stringWithFormat:@"Error in setLaunchAtStartup, LSSharedFileListInsertItemURL failed"]];
            goto cleanup;
        }
    }
    else
    {// Remove the app from the LoginItems list.
        [EventLogger Log:[NSString stringWithFormat:@"StartupLaunchController:setLaunchAtStartup Disabling Launch At Startup"]];

        OSStatus result =LSSharedFileListItemRemove(loginItemsRef,itemRef);
        if(result != noErr)
        {
            [EventLogger Log:[NSString stringWithFormat:@"Error in setLaunchAtStartup, LSSharedFileListItemRemove failed"]];
            goto cleanup;
        }
    }
cleanup:
    if (itemRef) CFRelease(itemRef);
    if(loginItemsRef) CFRelease(loginItemsRef);
}

+ (LSSharedFileListItemRef)itemRefInLoginItems
{
    NSArray *loginItems;
    LSSharedFileListItemRef itemRef = nil;
    CFURLRef itemUrl = nil;
    OSStatus status;
    
    
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    NSString* appUrl = [[NSURL fileURLWithPath:appPath] absoluteString];
    
    // Get the LoginItems list.
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Error in itemRefInLoginItems, LSSharedFileListCreate failed"]];
        goto cleanup;
    }
    
    // Iterate over the LoginItems.
    loginItems = (__bridge_transfer NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
    for (int i = 0; i < [loginItems count]; i++)
    {
        // Get the current LoginItem and resolve its URL.
        LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)[loginItems objectAtIndex:i];
        
        status = LSSharedFileListItemResolve(currentItemRef, 0, (CFURLRef *) &itemUrl, NULL);
        if (status != noErr)
        {
            //I don't think is an actual error, we're just going to assume it's not, and since we can't match it we continue
            continue;
            //NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            //[EventLogger Log:[NSString stringWithFormat:@"Error in itemRefInLoginItems, LSSharedFileListItemResolve failed: %@", error]];
            //error out;
        }
        
        // Compare the URLs for the current LoginItem and the app.
        if ([appUrl isEqualToString:[(__bridge NSURL *)(itemUrl) absoluteString]])
        {
            itemRef = currentItemRef;
            CFRelease(itemUrl);
            break;
        }
        CFRelease(itemUrl);
    }
    
cleanup:
    // Release the LoginItems lists.
    if(loginItemsRef) CFRelease(loginItemsRef);
    
    // Retain the LoginItem reference.
    if (itemRef != nil) CFRetain(itemRef);
    
    return itemRef;
}

@end
