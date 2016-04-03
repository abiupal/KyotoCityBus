//
//  Kyoto_CityBusDaysTimeTableController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/07/29.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//
#import "MyDefine.h"
#import "Kyoto_CityBusDaysTimeTableController.h"
#import "Kyoto_CityBusTimeTableController.h"
#import "PickupTimeTable.h"

@implementation Kyoto_CityBusDaysTimeTableController

@synthesize timeTable = _timeTable, busInfo = _busInfo;
@synthesize today = _today;

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LOG("START");
    
    if ( self.timeTable == nil )
    {
        Kyoto_CityBusTimeTableController *ttc = (Kyoto_CityBusTimeTableController *)[self parentViewController];
        self.title = ttc.title;
        self.busInfo = ttc.busInfo;
        self.timeTable = ttc.timeTable;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSHourCalendarUnit;
        NSDateComponents *comps = [cal components:unitFlags fromDate:[NSDate date]];
        hour = [comps hour];
    }
    
    LOG("END");
    return [self.timeTable countOfList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger n = indexPath.row;
    
    LOG("START");
    if (n == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BusInfoCell"];
        cell.userInteractionEnabled = NO;
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:self.busInfo];
    }
    else
    {
        n--;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"BusStopTimeLineCell"];

        NSString *timeMinutes = nil;
        if ([self.whichDays isEqualToString:@"Weekdays"] == YES)
            timeMinutes = [self.timeTable objectInWeekdayAtIndex:n];
        else if ([self.whichDays isEqualToString:@"Saturdays"] == YES)
            timeMinutes = [self.timeTable objectInSaturdayAtIndex:n];
        else
            timeMinutes = [self.timeTable objectInHolidayAtIndex:n];
    
        NSString *timeHour = [NSString stringWithFormat:@"%d",(int)(n +5)];
    
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        [label setText:timeHour];
        label = (UILabel *)[cell viewWithTag:2];
        [label setText:timeMinutes];
        
        if( hour == (n + 5))
            cell.selected = YES;
        else
            cell.selected = NO;
    }
    LOG("END");
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)moveHourCell
{
    if( 5 <= hour && hour <= 23 )
    {/* 5a.m:1 - 11p.m.:19 */
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:hour -4 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( 5 <= hour && hour <= 23 && self.today == YES )
    {/* 5a.m:1 - 11p.m.:19 */
        NSIndexPath *hourIndexPath = [NSIndexPath indexPathForRow:hour -4 inSection:0];
        if( [indexPath compare:hourIndexPath] == NSOrderedSame )
        {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
        }
    }
}


@end
