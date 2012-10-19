//
//  Kyoto_CityBusTimeTableController.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/07/06.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyWaitView;
@class PickupTimeTable;

@interface Kyoto_CityBusTimeTableController : UITabBarController {
    NSInteger todayIndex;
}

@property(nonatomic) BOOL downloading;

@property (weak,nonatomic) IBOutlet UIBarButtonItem *busstopNote;

@property (strong, nonatomic) MyWaitView *waitView;

@property (strong, nonatomic) NSURLRequest *requestURL;
@property (strong, nonatomic) NSURLConnection *connectionURL;
@property (strong, nonatomic) NSMutableData *receivedURL;

@property (strong, nonatomic) PickupTimeTable *timeTable;
@property (copy,nonatomic) NSString *busInfo, *noteString;


- (void)requestToURL:(NSURL *)url;
- (void)setTabBarInfo;

@end
