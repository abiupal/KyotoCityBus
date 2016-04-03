//
//  Kyoto_CityBusTimeTableController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/07/06.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//
#import "MyDefine.h"
#import "Kyoto_CityBusTimeTableController.h"
#import "MyWaitView.h"
#import "PickupTimeTable.h"
#import "PickupDataInHTML.h"
#import "Kyoto_CityBusDaysTimeTableController.h"
#import "noteBusstopController.h"

@implementation Kyoto_CityBusTimeTableController

@synthesize requestURL = _requestURL;
@synthesize connectionURL = _connectionURL;
@synthesize receivedURL = _receivedDataURL;

@synthesize waitView = _waitView;
@synthesize timeTable = _timeTable;
@synthesize downloading = _downloading;
@synthesize busInfo = _busInfo;
@synthesize busstopNote = _busstopNote;
@synthesize noteString = _noteString;

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        self.downloading = NO;
        todayIndex = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( self.receivedURL == nil )
    {
        self.receivedURL = [NSMutableData data];
    }
    [self.receivedURL setLength:0];
    if( self.waitView == nil )
    {
        self.waitView = [[MyWaitView alloc] init];
        [self.waitView setFrame:[self.view frame]];
        self.waitView.hidden = YES;
        [self.view addSubview:self.waitView];
    }
    if( self.timeTable == nil )
    {
        self.timeTable = [[PickupTimeTable alloc] init];
    }
	// Do any additional setup after loading the view, typically from a nib.
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger weekNo = [comps weekday];
    NSInteger day = [comps day];
    todayIndex = -1;
    switch ([comps month])
    {
        case 1:
            if( 1 <= day && day <= 4 ) todayIndex = 2;
            break;
        case 8:
            if( 14 <= day && day <= 16) todayIndex = 2;
            break;
        case 12:
            if( 29 <= day && day <= 31) todayIndex = 2;
            break;
    }
    if (todayIndex == -1)
    {
        if( weekNo == 7 ) todayIndex = 1;
        else if ( weekNo == 1 ) todayIndex = 2;
        else todayIndex = 0;
    }
}

- (void)viewDidUnload
{
    [self.receivedURL setLength:0];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.waitView = nil;
}


- (void)requestToURL:(NSURL *)url
{
    [self.receivedURL setLength:0];
    
    LOG("START, %@", url );
    
    self.requestURL = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    if( self.requestURL == nil ) goto END_REQUESTURL;
    self.connectionURL = [[NSURLConnection alloc] initWithRequest:self.requestURL delegate:self];
    if( self.connectionURL != nil )
    {
        [self.waitView setFrame:[self.view frame]];
        self.waitView.backgroundColor = [UIColor blueColor];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        self.waitView.hidden = NO;
        [self.waitView setNeedsDisplay];
        
        self.downloading = YES;
    }
    
    
END_REQUESTURL:
    
    self.downloading = NO;
    
    
    LOG("END, %@", self.downloading );
}


#pragma mark -- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedURL appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    LOG(@"Succeeded! Received %d bytes of data",[self.receivedURL length]);
   
    NSString *dataString = nil;
    dataString = [[NSString alloc] initWithData:self.receivedURL encoding:NSShiftJISStringEncoding];
    PickupDataInHTML *pickup = [[PickupDataInHTML alloc] init];

    [pickup pickupTimeTable:dataString dc:self.timeTable];
    if( 0 < [self.timeTable countOfList] )
    {
        [self setTabBarInfo];

        NSLog(@"Buses >> %d Found!!",[self.timeTable countOfList]);
        NSArray *a = [self childViewControllers];
        Kyoto_CityBusDaysTimeTableController *tv;
        for ( tv in a)
        {
            [[tv tableView] reloadData];
            tv.title = tv.whichDays;
            tv.today = NO;
        }
        tv = [a objectAtIndex:todayIndex];
        tv.today = YES;
        for ( tv in a)
        {
            [tv moveHourCell];
        }
    }
    
    self.waitView.hidden = YES;
    [self.waitView setNeedsDisplay];
    
    self.downloading = NO;    
}

#pragma mark -- TabBarItem

- (void)setTabBarInfo
{
    UITabBarItem *tbi = [self.tabBar.items objectAtIndex:0];
    tbi.title = @"Weekdays";
    if( todayIndex == 0 ) tbi.badgeValue = @"Today";
    
    tbi = [self.tabBar.items objectAtIndex:1];
    tbi.title = @"Saturdays";
    if( todayIndex == 1 ) tbi.badgeValue = @"Today";

    tbi = [self.tabBar.items objectAtIndex:2];
    tbi.title = @"Holidays";
    if( todayIndex == 2 ) tbi.badgeValue = @"Today";
    
    [self setSelectedIndex:todayIndex];
}

#pragma mark -- Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"noteBusStop"])
    {
        NoteBusstopController *bnc = (NoteBusstopController *)[segue destinationViewController];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *ext = [self.noteString pathExtension];
        NSString *name = [self.noteString stringByDeletingPathExtension];
        NSString *path = [bundle pathForResource:name ofType:ext];
        bnc.image = [UIImage imageWithContentsOfFile:path];
        
        bnc.title = self.busstopNote.title;
    }
}

@end
