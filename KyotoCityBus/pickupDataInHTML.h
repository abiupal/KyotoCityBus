//
//  pickupDataInHTML.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/05/30.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickupBusController;
@class PickupTimeTable;

@interface PickupDataInHTML : NSObject

- (void)pickupBuses:(NSString *)dataString dc:(PickupBusController *)dc;

- (void)pickupTimeTable:(NSString *)dataString dc:(PickupTimeTable *)dc;

@end
