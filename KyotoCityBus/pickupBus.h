//
//  pickupBuses.h
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/05/30.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickupBus : NSObject

@property(copy,nonatomic) NSString *destName;
@property(copy,nonatomic) NSString *subName;
@property(copy,nonatomic) NSString *no;
@property(copy,nonatomic) NSString *html;
@property(copy,nonatomic) NSString *note;

-(id)initWithNo:(NSString *)no destName:(NSString *)dest subName:(NSString *)sub html:(NSString *)html;

@end
