//
//  Kyoto_CityBusWeekdaysController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/05/28.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "Kyoto_CityBusWeekdaysController.h"

@implementation Kyoto_CityBusWeekdaysController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad:Weekdays" );
    if ( self.whichDays == nil )
        self.whichDays = @"Weekdays";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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



@end
