//
//  pickupDataInHTML.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/05/30.
//  Copyright (c) 2012(2014) wHITEgODDESS. All rights reserved.
//
#import "MyDefine.h"
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


// 2014/04/20
// <TR><TD bgcolor="#0000ff" align="center" valign="middle" width="10%" rowspan = "2" nowrap><FONT color="#ffffff" size="+1"><B>3</B></FONT></TD><TD bgcolor="#A1D8E6" width="80%" nowrap><FONT color="#000000"><SMALL>　　河原町通　　 Kawaramachi-dori St.</SMALL></FONT></TD><TD bgcolor="#eeeeee" align="center" valign="middle" rowspan = "2"><A href = "417011.htm"><IMG SRC="../image/busimg.gif" width="64" height="32" border="0" ALT="3系統 四条河原町・北白川仕伏町(上終町・京都造形芸大)行き"></A></TD></TR><TR><TD bgcolor="#eeeeee" width="80%" nowrap><SMALL></SMALL><BIG><B>四条河原町・北白川仕伏町(上終町・京都造形芸大)</B></BIG></TD></TR>

// 2016/04/03
//             <tr data-href="417011.htm" class="jump"><td bgcolor="#0000ff" align="center" valign="middle" width="10%" rowspan="2" nowrap><font color="#ffffff" size="+1"><b>3</b></font></td><td bgcolor="#A1D8E6" width="80%" nowrap><font color="#000000"><small>　　河原町通　　 Kawaramachi-dori St.</small></font></td><td bgcolor="#eeeeee" align="center" valign="middle" rowspan="2"><a href="417011.htm"><img src="../img/busimg.gif" width="64" height="32" border="0" alt="3系統 四条河原町・北白川仕伏町(上終町・京都造形芸大)行き"></a></td></tr>

- (void)pickupBuses:(NSString *)dataString dc:(PickupBusController *)dc

{
    NSRange foundResult = [dataString rangeOfString:@"系統番号"];    
    if( foundResult.location == NSNotFound ) return;
    
    [dc removeAll];
    
    // Check Download Data
    //LOG( " %@", dataString );

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
        foundResult = [dataString rangeOfString:@"><b>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"</b>" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [NSMutableString stringWithString:[dataString substringWithRange:foundResult]];
        no = [subString stringByReplacingOccurrencesOfString:@"<br>" withString:@" / "]; //"3"
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        
        /* 行き先１ */
        foundResult = [dataString rangeOfString:@"\"><small>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"</small>"  options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        sub = [dataString substringWithRange:foundResult]; //"　　河原町通　　 Kawaramachi-dori St."
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        // 空白文字削除
        NSString *reSub = [sub stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        foundResult = [dataString rangeOfString:@"><a href=\"" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"\"><img src=" options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        html = [dataString substringWithRange:foundResult];
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;

        
        /* 行き先２ */
        foundResult = [dataString rangeOfString:@"width=\"64\" height=\"32\" border=\"0\" alt=\"" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        /* backChecked */
        foundResult = [dataString rangeOfString:@"\"></a></td></tr>"  options:NSLiteralSearch range:range];
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        dest = [dataString substringWithRange:foundResult]; //"3系統 四条河原町・北白川仕伏町(上終町・京都造形芸大)行き"
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        if( range.length < 1 ) break;
        
        // SMALL
        if( reSub.length < 1 )
        {
            /* 行き先２ */
            foundResult = [dataString rangeOfString:@"nowrap><small>" options:NSLiteralSearch range:range];
            if( foundResult.location == NSNotFound ) break;
            range.location = NSMaxRange(foundResult);
            range.length = length -NSMaxRange(foundResult);
            if( range.length < 1 ) break;
            /* backChecked */
            foundResult = [dataString rangeOfString:@"</small>"  options:NSLiteralSearch range:range];
            backChecked = foundResult;
            foundResult.length = foundResult.location - range.location;
            foundResult.location = range.location;
            sub = [dataString substringWithRange:foundResult]; //""
            range.location = NSMaxRange(backChecked);
            range.length = length -NSMaxRange(backChecked);
            if( range.length < 1 ) break;
            
            reSub = [sub stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        // BIG
        if( reSub.length < 1 )
        {
            /* 行き先２ */
            foundResult = [dataString rangeOfString:@"<big><b>" options:NSLiteralSearch range:range];
            if( foundResult.location == NSNotFound ) break;
            range.location = NSMaxRange(foundResult);
            range.length = length -NSMaxRange(foundResult);
            if( range.length < 1 ) break;
            /* backChecked */
            foundResult = [dataString rangeOfString:@"</b>"  options:NSLiteralSearch range:range];
            backChecked = foundResult;
            foundResult.length = foundResult.location - range.location;
            foundResult.location = range.location;
            sub = [dataString substringWithRange:foundResult]; //"四条河原町・北白川仕伏町(上終町・京都造形芸大)"
            range.location = NSMaxRange(backChecked);
            range.length = length -NSMaxRange(backChecked);
            if( range.length < 1 ) break;
        }
        
        NSLog(@"BUS >> %@ : %@,%@ : %@",no, dest, sub, html);
        [dc addPickupBusWithNo:no destName:dest subName:sub html:html];

        foundResult = [dataString rangeOfString:@"</big></td></tr>"options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound ) break;
    }
}


- (void)pickupTimeTable:(NSString *)dataString dc:(PickupTimeTable *)dc
{
    // Check Download Data
    LOG( " %@", dataString );
    
    //    NSRange foundResult = [dataString rangeOfString:@"年末年始　12月29日～1月4日</font></td>"];
    // 2016/04/03
    //お　　盆　　8月14日～8月16日<br>
    //年末年始　12月29日～1月3日
    // </font>    
    // </td>
    // </tr>
    NSRange foundResult = [dataString rangeOfString:@"8月14日～8月16日"];
    if( foundResult.location == NSNotFound ) return;
    
    [dc removeAll];
    
    NSRange range, backChecked;
    NSUInteger length = [dataString length];
    NSString *subString, *tag, *tag2;
    NSInteger i;
    for ( i = 5; i < 24; i++ )
    {
        if( foundResult.location == NSNotFound )
        {
            subString =@"　";
            [dc addWeekday:subString];
            [dc addSaturday:subString];
            [dc addHoliday:subString];
            continue;
        }
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;

        
        tag = [NSString stringWithFormat:@"</td><td>%d</td><td",i];
        
        /* ５時 */ 
        foundResult = [dataString rangeOfString:@"<tr bgcolor=\"#ffffff\" align=\"center\"><td>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound )
        {
            subString =@"　";
            [dc addWeekday:subString];
            [dc addSaturday:subString];
            [dc addHoliday:subString];
            continue;
        }
        range.location = NSMaxRange(foundResult);
        range.length = length -NSMaxRange(foundResult);
        if( range.length < 1 ) break;
        
        /* weekday */
        foundResult = [dataString rangeOfString:tag options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound )
        {
            subString =@"　";
            [dc addWeekday:subString];
            [dc addSaturday:subString];
            [dc addHoliday:subString];
            continue;
        }
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        [dc addWeekday:subString];
        // NSLog(@"%d >> %@, weekday", i, subString);
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        
        backChecked = [dataString rangeOfString:@">" options:NSLiteralSearch range:range];
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        
        /* saturday */
        foundResult = [dataString rangeOfString:tag options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound )
        {
            foundResult = [dataString rangeOfString:tag2 options:NSLiteralSearch range:range];
            if( foundResult.location == NSNotFound )
            {
                subString =@"　";
                [dc addSaturday:subString];
                [dc addHoliday:subString];
                continue;
            }
        }
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        subString = [subString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        [dc addSaturday:subString];
        // NSLog(@"%d >> %@, saturday", i, subString);
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);
        
        backChecked = [dataString rangeOfString:@">" options:NSLiteralSearch range:range];
        range.location = NSMaxRange(backChecked);
        range.length = length -NSMaxRange(backChecked);

        /* holiday */
        foundResult = [dataString rangeOfString:@"</td></tr>" options:NSLiteralSearch range:range];
        if( foundResult.location == NSNotFound )
        {
            subString =@"　";
            [dc addHoliday:subString];
            continue;
        }
        backChecked = foundResult;
        foundResult.length = foundResult.location - range.location;
        foundResult.location = range.location;
        subString = [dataString substringWithRange:foundResult];
        subString = [subString stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
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
