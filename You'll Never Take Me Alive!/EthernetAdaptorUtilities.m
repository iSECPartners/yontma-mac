//
//  EthernetAdaptorCollection.m
//  You'll Never Take Me Alive!
//
//  Created by Tom on 2/18/14.
//  Copyright (c) 2014 iSEC Partners. All rights reserved.
//

#import "EthernetAdaptorUtilities.h"

@implementation EthernetAdaptorUtilities


+(Boolean) isIdentical:(NSMutableArray*)first :(NSMutableArray*)second
{
    if([first count] != [second count])
        return false;
    for(EthernetAdaptor *ea in first)
    {
        Boolean foundThisSameAdaptor = false;
        for(EthernetAdaptor* oa in second)
        {
            if([ea isIdenticalTo: oa])
                foundThisSameAdaptor = true;
        }
        if(!foundThisSameAdaptor)
            return false;
    }
    
    for(EthernetAdaptor* oa in second)
    {
        Boolean foundThisSameAdaptor = false;
        for(EthernetAdaptor* ea in first)
        {
            if([ea isIdenticalTo: oa])
                foundThisSameAdaptor = true;
        }
        if(!foundThisSameAdaptor)
            return false;
    }
    
    return true;
}

+(EthernetAdaptor*) findThisAdaptor:(EthernetAdaptor*)needle InThisList:(NSMutableArray*)ethernetAdaptorList
{
    for(EthernetAdaptor* ea in ethernetAdaptorList)
    {
        if([needle nameMatches:ea])
            return ea;
    }
    return nil;
}


@end
