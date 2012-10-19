//
//  Kyoto_CityBusDaysTimeTableController.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/07/29.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickupBus;
@class PickupTimeTable;

@interface Kyoto_CityBusDaysTimeTableController : UITableViewController
{
    NSInteger hour;
}

@property (weak,nonatomic) PickupTimeTable *timeTable;
@property (strong,nonatomic) NSString *whichDays;
@property (weak,nonatomic) NSString *busInfo;
@property BOOL today;

-(void)moveHourCell;

@end
