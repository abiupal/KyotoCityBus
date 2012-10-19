//
//  pickupBusController.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/06/06.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickupBus;

@interface PickupBusController : NSObject
{
    NSArray *db;
}

@property (nonatomic, copy) NSMutableArray *masterList;

- (void)removeAll;
- (unsigned)countOfList;
- (PickupBus *)objectInListAtIndex:(unsigned)theIndex;
- (void)addPickupBusWithNo:(NSString *)no destName:(NSString *)dest subName:(NSString *)sub html:(NSString *)html;
- (void)addNoteDataFromBusstop:(NSString *)busstop;

@end
