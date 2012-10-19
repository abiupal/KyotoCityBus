//
//  MyBusStopSelector.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/08.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBusStopSelector : NSObject
{
    NSArray *db;
}

@property(copy,nonatomic) NSString *busStop, *html;
@property(strong,nonatomic) NSMutableArray *found;
@property(nonatomic) BOOL hasNote;

-(id)initWithCheckingString:(NSString *)checked;
-(BOOL)foundNameFromDB;

@end
