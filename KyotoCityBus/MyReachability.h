//
//  MyReachability.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/01.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface MyReachability : NSObject
{
    SCNetworkReachabilityFlags flags;
}

-(id)initWithHostname:(NSString *)hostname;
- (BOOL)isReachable;

@end
