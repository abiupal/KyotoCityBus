//
//  PickupTimeTable.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/07/29.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickupTimeTable : NSObject

@property (strong,nonatomic) NSMutableArray *weekday;
@property (strong,nonatomic) NSMutableArray *saturday;
@property (strong,nonatomic) NSMutableArray *holiday;

-(void) addWeekday:(NSString *)data;
-(void) addSaturday:(NSString *)data;
-(void) addHoliday:(NSString *)data;

- (void)removeAll;
- (unsigned)countOfList;

- (NSString *)objectInWeekdayAtIndex:(unsigned)theIndex;
- (NSString *)objectInSaturdayAtIndex:(unsigned)theIndex;
- (NSString *)objectInHolidayAtIndex:(unsigned)theIndex;


@end
