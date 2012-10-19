//
//  pickupBuses.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/05/30.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "pickupBus.h"

@implementation PickupBus

@synthesize destName = _destName;
@synthesize subName = _subName;
@synthesize no = _no;
@synthesize html = _html;
@synthesize note = _note;

-(id)initWithNo:(NSString *)no destName:(NSString *)dest subName:(NSString *)sub html:(NSString *)html
{
    self = [super init];
    if( self != nil )
    {
        _no = no;
        _destName = dest;
        _subName = sub;
        _html = html;
    }
    return self;
}

@end
