//
//  Kyoto_CityBusMasterViewController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/05/28.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "Kyoto_CityBusMasterViewController.h"
#import "pickupDataInHTML.h"
#import "pickupBus.h"
#import "pickupBusController.h"
#import "MyWaitView.h"
#import "Kyoto_CityBusTimeTableController.h"
#import "MyReachability.h"
#import "MyBusStopSelector.h"

@implementation Kyoto_CityBusMasterViewController
@synthesize busStop = _busStop;
@synthesize requestURL = _requestURL;
@synthesize connectionURL = _connectionURL;
@synthesize receivedURL = _receivedDataURL;
@synthesize dataController = _dataController;
@synthesize waitView = _waitView;
@synthesize searchedBusStop = _searchedBusStop;
@synthesize searchedTitle = _searchedTitle, searchedSubTitle = _searchedSubTitle, noteString = _noteString;
@synthesize found = _found;
@synthesize hasNote = _hasNote;

#pragma mark - Inside

- (void)checkingNetworkConnection
{
    checkingConnection = NO;
    MyReachability *myCheck = [[MyReachability alloc] initWithHostname:@"www.google.com"];
    if( [myCheck isReachable] == NO )
    {
        NSString *messageString = [NSString stringWithFormat:@"Check Network Setting."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Reachability"
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil
                              ];
        [alert show];
    }
    else  checkingConnection = YES;
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret = 0;
    if( selectedBusstopName == YES )
        ret = [self.found count];
    else
        ret = [self.dataController countOfList];
    
    return ret;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if( selectedBusstopName == YES )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"KyotoCityBusStopCell"];
        NSString *s = [self.found objectAtIndex:indexPath.row];
        NSArray *a = [s componentsSeparatedByString:@","];
        [[cell textLabel] setText:[a objectAtIndex:2]];
        [[cell detailTextLabel] setText:[a objectAtIndex:1]];
    }
    else
    {
        
    NSUInteger maxCount = [self.dataController countOfList];
    NSInteger n = indexPath.row;
    if( n == 0 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"KyotoCityBusStopCell"];

        [[cell textLabel] setText:self.searchedTitle];
        [[cell detailTextLabel] setText:self.searchedSubTitle];
        // cell.userInteractionEnabled = NO;
    }
    else if( n == (maxCount -1))
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"KyotoCityBusStopCell"];
        
        NSString *string = [NSString stringWithFormat:@"検索した系統数 : %d",maxCount -2];
        [[cell textLabel] setText:string];
        [[cell detailTextLabel] setText:self.searchedSubTitle];
        // cell.userInteractionEnabled = NO;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"KyotoCityBusCell"];
        
        PickupBus *pickupBusAtIndex = [self.dataController objectInListAtIndex:n -1];
    
        NSString *title = [NSString stringWithFormat:@"%@ : %@",pickupBusAtIndex.no, pickupBusAtIndex.destName];
        [[cell textLabel] setText:title];
        [[cell detailTextLabel] setText:pickupBusAtIndex.subName];
        // cell.userInteractionEnabled = YES;
    }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( selectedBusstopName == NO ) return;
    
    selectedBusstopName = NO;
    [self.busStop resignFirstResponder];
    
    
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    NSString *s = [self.found objectAtIndex:selectedRowIndex.row];
    NSArray *a = [s componentsSeparatedByString:@","];
    self.busStop.text = [a objectAtIndex:2];
    self.noteString = [a objectAtIndex:3];
    if( [self.noteString isEqualToString:@"nothing"] == YES )
        self.hasNote = NO;
    else
        self.hasNote = YES;
    
    
    s = [NSString stringWithFormat:@"http://www.city.kyoto.jp/kotsu/busdia/hyperdia/%@",[a objectAtIndex:0]];
    googleSearched = YES;
    NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self requestToURL:url];    
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( self.busStop == textField )
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Initialize

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    googleSearched = NO;
    foundBusstopURL = NO;
    selectedBusstopName = NO;
    checkingConnection = NO;
    
	// Do any additional setup after loading the view, typically from a nib.
    // [self checkingNetworkConnection];
}

- (void)viewDidUnload
{
    [self setBusStop:nil];
    [self.receivedURL setLength:0];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.waitView = nil;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL)requestToURL:(NSURL *)url
{
    [self.receivedURL setLength:0];
    
    self.requestURL = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    if( self.requestURL == nil ) goto END_REQUESTURL;
    self.connectionURL = [[NSURLConnection alloc] initWithRequest:self.requestURL delegate:self];
    if( self.connectionURL != nil )
    {
        [self.waitView setFrame:[self.view frame]];
        if( googleSearched == NO )
            self.waitView.backgroundColor = [UIColor greenColor];
        else
            self.waitView.backgroundColor = [UIColor orangeColor];
        self.waitView.hidden = NO;
        [self.waitView setNeedsDisplay];
        
        return YES;
    }
    
    
END_REQUESTURL:
    self.busStop.enabled = YES;
    
    return NO;
}

#pragma mark -- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedURL appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([error code] ==  NSURLErrorNotConnectedToInternet)
    {
        [connection cancel];
        checkingConnection = NO;
        
        self.waitView.hidden = YES;
        [self.waitView setNeedsDisplay];
        
        self.busStop.enabled = YES;
        selectedBusstopName = NO;
        [self.found removeAllObjects];
        [self.tableView reloadData];
        
        NSString *messageString = [NSString stringWithFormat:@"Check Network Setting."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Reachability"
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil
                              ];
        [alert show];

    }
}

- (void)notFoundMessage
{
    NSString *messageString = [NSString stringWithFormat:@"Not Found %@.\nTry to input other text and search.", self.busStop.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found"
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil
                          ];
    [alert show];
    self.waitView.hidden = YES;
    [self.waitView setNeedsDisplay];
    
    self.busStop.enabled = YES;

}

- (BOOL)checkBusStop:(NSString *)dataString foundRange:(NSRange *)returnRange
{
    
    NSUInteger length = [dataString length];
    NSRange range, foundResult;
    
    range = NSMakeRange(0, length);
    
    foundResult = [dataString rangeOfString:@"<div id=\"ires\">"];
    if( foundResult.location == NSNotFound )
        return NO;
    range.location = NSMaxRange(foundResult);
    range.length = length -NSMaxRange(foundResult);

    
    for (;;)
    {
        foundResult = [dataString rangeOfString:self.busStop.text options:0 range:range];
        if( foundResult.location == NSNotFound )
            return NO;
        range.location = NSMaxRange(foundResult) +4;
        range.length = 40;
        
        range = [dataString rangeOfString:@"に<b>" options:0 range:range];
        if( range.location == NSNotFound )
        {
            range.location = NSMaxRange(foundResult);
            range.length = length -NSMaxRange(foundResult);
            continue;
        }
        else
            break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        
        foundResult = [dataString rangeOfString:@"停車する系統" options:0 range:range];
        if( foundResult.location != NSNotFound ) break;
    }
    returnRange->location = NSMaxRange(foundResult);
    returnRange->length = length -NSMaxRange(foundResult);
    
    return YES;
}

- (void)pickupBusStopName:(NSString *)dataString
{
    NSUInteger length = [dataString length];
    NSRange range, foundResult, backChecked;
    NSString *subString = nil;
    
    range = NSMakeRange(0, length);
    foundResult = [dataString rangeOfString:@"<P class=\"buss1\">" options:NSLiteralSearch range:range];
    if( foundResult.location != NSNotFound )
    {
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        foundResult = [dataString rangeOfString:@"</P>" options:0 range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        
        range = [subString rangeOfString:self.busStop.text];
        if( range.location != NSNotFound )
        {
            self.searchedBusStop = subString;
        }
        self.searchedTitle = [NSString stringWithFormat:@"検索したバス停 : %@",subString];
    }
    
    self.searchedSubTitle = @"";
    range = NSMakeRange(0, length);
    foundResult = [dataString rangeOfString:@"<P class=\"buss2\">" options:NSLiteralSearch range:range];
    if( foundResult.location != NSNotFound )
    {
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        foundResult = [dataString rangeOfString:@"</P>" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        
        range = [subString rangeOfString:self.busStop.text];
        if( range.location != NSNotFound )
        {
            self.searchedBusStop = subString;
        }
        self.searchedSubTitle = subString;
    }
    range = NSMakeRange(0, length);
    foundResult = [dataString rangeOfString:@"<P class=\"buss3\">" options:NSLiteralSearch range:range];
    if( foundResult.location != NSNotFound )
    {
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        foundResult = [dataString rangeOfString:@"</P>" options:0 range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        
        range = [subString rangeOfString:self.busStop.text];
        if( range.location != NSNotFound )
        {
            self.searchedBusStop = subString;
        }
        self.searchedSubTitle = [NSString stringWithFormat:@"%@ / %@",self.searchedSubTitle, subString];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    char buffer[64], i;
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedURL length]);
    NSString *dataString = nil;
    if( googleSearched == NO )
    {
        NSRange foundResult;
        dataString = [[NSString alloc] initWithData:self.receivedURL encoding:NSUTF8StringEncoding];
        if( [self checkBusStop:dataString foundRange:&foundResult] == NO )
        {
            [self notFoundMessage];
            return;
        }
        
        foundResult = [dataString rangeOfString:@"http://www.city.kyoto.jp/kotsu/busdia/hyperdia/menu" options:NSLiteralSearch range:foundResult];
        if( foundResult.location != NSNotFound )
        {
            foundResult.length += 10;
            NSString *nextString = [dataString substringWithRange:foundResult];
            memset(buffer, 0, sizeof(buffer));
            strncat(buffer, [nextString UTF8String], 63);
            for( i = 51; i < 63; i++)
            {
                if( buffer[i] == '.')
                {
                    buffer[i +4] = '\0';
                    i = 64;
                    googleSearched = YES;
                }
            }
            if( strlen(buffer) < 63 )
            {
                NSString *baseString = [NSString stringWithUTF8String:buffer];
                NSURL *url = [NSURL URLWithString:[baseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [self requestToURL:url];
            }
        }
        else
        {
            [self notFoundMessage];
        }
    }
    else
    {
        dataString = [[NSString alloc] initWithData:self.receivedURL encoding:NSShiftJISStringEncoding];
        PickupDataInHTML *pickup = [[PickupDataInHTML alloc] init];
        [pickup pickupBuses:dataString dc:self.dataController];
        if( 0 < [self.dataController countOfList] )
        {
            NSLog(@"Buses >> %d Found!!",[self.dataController countOfList]);
            [[self tableView] reloadData];
            [self pickupBusStopName:dataString];
            if( self.hasNote == YES )
                [self.dataController addNoteDataFromBusstop:self.busStop.text];
        }
        self.waitView.hidden = YES;
        [self.waitView setNeedsDisplay];

        self.busStop.enabled = YES;
    }
}

#pragma mark -- Action

- (IBAction)searchBusStop:(id)sender
{
    if( self.busStop.enabled != YES ) return;
    /*
    if( checkingConnection == NO )
    {
        [self checkingNetworkConnection];
        if( checkingConnection == NO ) return;
    }*/
    
    if( [self.busStop.text length] < 1 )
    {
        return;
    }
    
    self.hasNote = NO;
    self.busStop.enabled = NO;
    /* 愛染倉　最寄り施設から検索 www.city.kyoto.jp/kotsu/busdia */
    MyBusStopSelector *mbss = [[MyBusStopSelector alloc] initWithCheckingString:self.busStop.text];
    NSString *baseString;
    if( [mbss foundNameFromDB] == YES )
    {
        self.busStop.text = mbss.busStop;
        if( [mbss.found count] == 1 )
        {
            baseString = [NSString stringWithFormat:@"http://www.city.kyoto.jp/kotsu/busdia/hyperdia/%@",mbss.html];
            googleSearched = YES;
            selectedBusstopName = NO;
            // self.hasNote = mbss.hasNote;
            NSString *s = [mbss.found objectAtIndex:0];
            NSArray *a = [s componentsSeparatedByString:@","];
            self.busStop.text = [a objectAtIndex:2];
            self.noteString = [a objectAtIndex:3];
            if( [self.noteString isEqualToString:@"nothing"] == YES )
                self.hasNote = NO;
            else
            {
                self.hasNote = YES;
            }
        }
        else
        {
            selectedBusstopName = YES;
            self.found = mbss.found;
            [self.tableView reloadData];
            self.busStop.enabled = YES;
            return;
        }
    }
    else
    {
        NSString *searchString = [NSString stringWithFormat:@"%@ 停車する系統 site:www.city.kyoto.jp",self.busStop.text];
        baseString = [NSString stringWithFormat:@"http://www.google.co.jp/search?q=%@&ie=UTF-8&oe=UTF-8",searchString];
        googleSearched = NO;
    }
    NSURL *url = [NSURL URLWithString:[baseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self requestToURL:url];
}

#pragma mark -- Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([[segue identifier] isEqualToString:@"Segue_TimeTable"]) 
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        
        PickupBus *pickupBusAtIndex = [self.dataController objectInListAtIndex:selectedRowIndex.row -1];
        NSString *baseString = [NSString stringWithFormat:@"http://www.city.kyoto.jp/kotsu/busdia/hyperdia/%@", pickupBusAtIndex.html];
        NSURL *url = [NSURL URLWithString:[baseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        Kyoto_CityBusTimeTableController *controller = [segue destinationViewController];
        
        controller.busInfo = self.searchedBusStop;
        controller.title = [NSString stringWithFormat:@"%@ : %@",pickupBusAtIndex.no, pickupBusAtIndex.destName];
        controller.busstopNote.enabled = self.hasNote;
        if( self.hasNote == YES )
        {
            baseString = [NSString stringWithFormat:@"%@",pickupBusAtIndex.note];
            controller.busstopNote.title = baseString;
            controller.noteString = self.noteString;
        }
        
        /*
        MyReachability *myCheck = [[MyReachability alloc] initWithHostname:@"www.google.com"];
        if( [myCheck isReachable] == NO )
        {
            NSString *messageString = [NSString stringWithFormat:@"Check Network Setting."];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Reachability"
                                                            message:messageString
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil
                                  ];
            [alert show];
        }
        else */
            [controller requestToURL:url];
    }
}

@end
