//
//  PickupTimeTable.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/07/29.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import "PickupTimeTable.h"

@implementation PickupTimeTable

@synthesize weekday = _weekday;
@synthesize saturday = _saturday;
@synthesize holiday = _holiday;

-(id)init
{
    self = [super init];
    if (self != nil )
    {
        if (self.weekday == nil)
        {
            self.weekday = [NSMutableArray arrayWithCapacity:19];
        }
        if (self.saturday == nil)
        {
            self.saturday = [NSMutableArray arrayWithCapacity:19];
        }
        if (self.holiday == nil)
        {
            self.holiday = [NSMutableArray arrayWithCapacity:19];
        }
    }
    return self;
}


-(void) addWeekday:(NSString *)data
{
    [self.weekday addObject:data];
}
-(void) addSaturday:(NSString *)data
{
    [self.saturday addObject:data];
}
-(void) addHoliday:(NSString *)data
{
    [self.holiday addObject:data];
}

- (void)removeAll
{
    [self.weekday removeAllObjects];
    [self.saturday removeAllObjects];
    [self.holiday removeAllObjects];
}

- (unsigned)countOfList
{
    NSUInteger max = [self.weekday count];
    
    if (0 < max) {
        max++;
    }
        
    return max;
}
- (NSString *)objectInWeekdayAtIndex:(unsigned)theIndex
{
    NSString *str = [self.weekday objectAtIndex:theIndex];
    
    return str;
}
- (NSString *)objectInSaturdayAtIndex:(unsigned)theIndex
{
    NSString *str = [self.saturday objectAtIndex:theIndex];
    
    return str;
}
- (NSString *)objectInHolidayAtIndex:(unsigned)theIndex
{
    NSString *str = [self.holiday objectAtIndex:theIndex];
    
    return str;
}



@end
