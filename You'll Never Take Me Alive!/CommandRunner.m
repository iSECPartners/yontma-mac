//
//  CommandRunner.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/20/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "CommandRunner.h"

@implementation CommandRunner

+(NSString*) runTaskGetOutput:(NSString*)cmd
{
    [EventLogger Log:[NSString stringWithFormat:@"Running command: %@", cmd]];
    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *stdout;
    stdout = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    return stdout;
}


+(void) runAsRootTask:(char*)cmd Args:(NSString*)args
{
    [EventLogger Log:[NSString stringWithFormat:@"Running command as root: %s", cmd]];
    
    FILE *pipe = NULL;
    OSStatus status;
    
    NSArray* arr = [args componentsSeparatedByString:@" "];
    char** cargs = alloca(sizeof(char*) * ([arr count] + 1));
    
    [CommandRunner nsStringToCharArray:arr Into:cargs];
    status = AuthorizationExecuteWithPrivileges([CommandRunner getRights:false],
                                                cmd,
                                                kAuthorizationFlagDefaults,
                                                cargs,
                                                &pipe);
    if (status != noErr)
    {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [EventLogger Log:[NSString stringWithFormat:@"Could not execute privileged action: %@", error]];
    }
}

+(void) dropPrivileges
{
    [CommandRunner getRights:true];
}

//==============================================================================

+(AuthorizationRef) getRights:(Boolean)dropThem
{
    static Boolean gotRights = false;
    
    static AuthorizationRef authorizationRef;
    
    static AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    static AuthorizationRights rights = {1, &right};
    static AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    OSStatus status;
    
    if(dropThem)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Asking to drop rights..."]];
        if(gotRights)
        {
            gotRights = false;
            authorizationRef = nil;
            [EventLogger Log:[NSString stringWithFormat:@"Rights were found and abandoned..."]];
        }
    }
    else if(!gotRights)
    {
        [EventLogger Log:[NSString stringWithFormat:@"Prompting user for admin rights..."]];
        
        // Create authorization reference
        status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment,
                                     kAuthorizationFlagDefaults, &authorizationRef);
        if (status != errAuthorizationSuccess)
        {
            [EventLogger Log:[NSString stringWithFormat:@"Error Creating Initial Authorization: %d", status]];
            gotRights = false;
            return nil;
        }
        
        // Call AuthorizationCopyRights to determine or extend the allowable rights.
        status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
        if (status != errAuthorizationSuccess)
        {
            [EventLogger Log:[NSString stringWithFormat:@"Copy Rights Unsuccessful: %d", status]];
            gotRights = false;
            return nil;
        }
        
        [EventLogger Log:[NSString stringWithFormat:@"Got rights..."]];
        gotRights = true;
    }
    
    return authorizationRef;
}


+(void) nsStringToCharArray:(NSArray*)arr Into:(char**)dest
{
    int i=0;
    for(i=0; i<[arr count];i++)
        dest[i] = [(NSString*)[arr objectAtIndex:i] UTF8String];
    dest[i] = NULL;
}

@end
