//
//  pickupDataInHTML.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/05/30.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import "pickupDataInHTML.h"
#import "PickupBus.h"
#import "pickupBusController.h"
#import "PickupTimeTable.h"

@implementation PickupDataInHTML

- (id)init
{
    self = [super init];
    
    return self;
}
- (void)pickupBuses:(NSString *)dataString dc:(PickupBusController *)dc

{
    NSRange foundResult = [dataString rangeOfString:@"系統番号"];    
    if( foundResult.location == NSNotFound ) return;
    
    [dc removeAll];

    NSRange range, backChecked;
    NSUInteger length = [dataString length];
    NSMutableString *subString;
    NSString *no, *dest, *sub, *html;
    for (;;)
    {
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* 系統 */
        foundResult = [dataString rangeOfString:@"><B>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        
        /* backChecked */
        foundResult = [dataString rangeOfString:@"</B>" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [NSMutableString stringWithString:[dataString substringWithRange:foundResult]];
        /*
        foundResult = [subString rangeOfString:@"<br>"];
        if( foundResult.location != NSNotFound )
            [subString replaceCharactersInRange:foundResult withString:@" / "];
         no = subString;
        */
        no = [subString stringByReplacingOccurrencesOfString:@"<br>" withString:@" / "];
        
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        /* 行き先１ */
        foundResult = [dataString rangeOfString:@"nowrap><SMALL>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"<BR>"  options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        sub = [dataString substringWithRange:foundResult];
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        /* 行き先２ */
        foundResult = [dataString rangeOfString:@"</SMALL><BIG><B>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"</B>"  options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        dest = [dataString substringWithRange:foundResult];
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;

        foundResult = [dataString rangeOfString:@"><A href = \"" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"\"><IMG SRC=" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        html = [dataString substringWithRange:foundResult];
        NSLog(@"BUS >> %@ : %@,%@ : %@",no, dest, sub, html);
        [dc addPickupBusWithNo:no destName:dest subName:sub html:html];
        
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        
        foundResult = [dataString rangeOfString:@"</A></TD></TR>"options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
    }
}


- (void)pickupTimeTable:(NSString *)dataString dc:(PickupTimeTable *)dc
{
    NSRange foundResult = [dataString rangeOfString:@"年末年始　12月29日～1月4日"];
    if( foundResult.location == NSNotFound ) return;
    
    [dc removeAll];
    
    NSRange range, backChecked;
    NSUInteger length = [dataString length];
    NSString *subString, *tag;
    NSInteger i;
    
    for ( i = 5; i < 24; i++ )
    {
        tag = [NSString stringWithFormat:@"</TD><TD>%d</TD><TD>",i];
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        
        /* ５時 */ 
        foundResult = [dataString rangeOfString:@"<TR bgcolor=\"#ffffff\" align=\"center\"><TD>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        
        /* weekday */
        foundResult = [dataString rangeOfString:tag options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        [dc addWeekday:subString];
        // NSLog(@"%d >> %@, weekday", i, subString);
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        
        /* saturday */
        foundResult = [dataString rangeOfString:tag options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        [dc addSaturday:subString];
        // NSLog(@"%d >> %@, saturday", i, subString);
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        
        /* holiday */
        foundResult = [dataString rangeOfString:@"</TD></TR>" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        [dc addHoliday:subString];
        // NSLog(@"%d >> %@, holiday", i, subString);
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
    }
}

@end
