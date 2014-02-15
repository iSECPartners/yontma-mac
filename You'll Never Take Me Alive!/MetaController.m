//
//  MetaController.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "MetaController.h"

@implementation MetaController

+(void)initYontmaState
{
    [[AppState yontmaState] setIsConnectedToACPower:[PowerController isAttachedToPower]];
    [[AppState yontmaState] setEthernetAdaptors:[EthernetController getInterfaces]];
    
    ErrorStates errors = [LaptopSettingsController getLaptopConfigurationErrors];
    [[AppState yontmaState] setHasFilevaultError:errors & FileVaultError];
    [[AppState yontmaState] setHasPowerSettingsError:errors & PowerSettingsError];
    
    [[AppState yontmaState] setRunAtStartup:[StartupLaunchController isLaunchAtStartup]];
    
    [ScreenSaverController screensaverController];
    [Hibernator hibernatorController];
}

+(void) detectChanges
{
    //Detect a Power Change ====================================================
    Boolean oldPowerState = [[AppState yontmaState] isConnectedToACPower];
    Boolean currentPowerState = PowerController.isAttachedToPower;
    
    if(oldPowerState != currentPowerState)
    {
        [EventLogger Log:[NSString stringWithFormat:@"MetaController:detectChanges Posting Power Change Notification. Old: %d New:%d", oldPowerState, currentPowerState]];
        [[AppState yontmaState] setIsConnectedToACPower:currentPowerState];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"powerStatusChanged" object:self];
    }
    
    //Detect an Ethernet Change ================================================
    NSMutableArray* oldEthernetAdaptors = [[AppState yontmaState] ethernetAdaptors];
    NSMutableArray* currentEthernetAdaptors = [EthernetController getInterfaces];
    
    if(![EthernetAdaptorUtilities isIdentical:oldEthernetAdaptors :currentEthernetAdaptors])
    {
        [EventLogger Log:[NSString stringWithFormat:@"MetaController:detectChanges Posting Ethernet Change Notification."]];
        [[AppState yontmaState] setEthernetAdaptors:currentEthernetAdaptors];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ethernetStatusChanged" object:self];
    }
    
}

@end
