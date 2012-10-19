//
//  Kyoto_CityBusMasterViewController.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/05/28.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickupBusController;
@class MyWaitView;

@interface Kyoto_CityBusMasterViewController : UITableViewController <UITextFieldDelegate,NSURLConnectionDelegate>
{
    BOOL checkingConnection, googleSearched, foundBusstopURL, selectedBusstopName;
}

@property (strong, nonatomic) MyWaitView *waitView;

@property (strong, nonatomic) NSURLRequest *requestURL;
@property (strong, nonatomic) NSURLConnection *connectionURL;
@property (strong, nonatomic) NSMutableData *receivedURL;

@property (weak, nonatomic) IBOutlet UITextField *busStop;

@property (strong, nonatomic) PickupBusController *dataController;

@property (copy,nonatomic)  NSString *searchedBusStop, *searchedTitle, *searchedSubTitle, *noteString;
@property (strong,nonatomic) NSMutableArray *found;
@property (nonatomic) BOOL hasNote;

- (IBAction)searchBusStop:(id)sender;

@end
