//
//  MyReachability.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/01.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import "MyReachability.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation MyReachability

-(id)initWithHostname:(NSString *)hostname
{
    self = [super init];
    if( self != nil )
    {
        SCNetworkReachabilityRef myRef = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
        if( myRef != nil )
            SCNetworkReachabilityGetFlags(myRef, &flags);
    }
    
    return self;
}

- (BOOL)isReachable
{
    return (flags & kSCNetworkReachabilityFlagsReachable);
}

@end
