//
//  pickupBusController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 12/06/06.
//  Copyright (c) 2012 wHITEgODDESS. All rights reserved.
//

#import "pickupBusController.h"
#import "pickupBus.h"


@interface PickupBusController ()
- (void)initializeDefaultDataList;
@end

@implementation PickupBusController

@synthesize masterList = _masterList;

-(void)setMasterList:(NSMutableArray *)newList
{
    if( _masterList != newList )
        _masterList = [newList mutableCopy];
}

-(void)initializeDefaultDataList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.masterList = list;
    
    db = @[
    @"四条河原町,B,B,F,F,F,F,F,E,E,E,E,D,D,D,D,D,D,D,C,C,C,C,A,A,A,A,I,I,H,H,G,G",
    @"京都駅前,A2,A1,A2,A2,A3,B1,B2,B2,B3,B3,B3,C4,C4,C5,C4,C5,C5,C4,C4,C1,C1,C1,C4,D3,D3,D1,D2,D2",
    @"三条京阪前,6,6,4,4,4,3,3,3,2,1",
    @"京都駅八条口アバンティ前,6,6,6,5,1,1,1,1,2,3,4",
    @"北大路バスターミナル,C,C,B,C,B,A,A,D,E,E,E,G,F,G,E,F,F,F,F,G",
    @"四条烏丸,B,B,B,B,F,F,A,A,A,E,E,E,E,E,E,E,D,D,D,D,D,D,D,D,D,D,C,C,C,C,C,C,C",
    @"四条大宮,1,1,1,1,1,1,1,1,1,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,2,2,2,2,3,3,3,3,3,3,8,8,8,8,7,7,7,6,6",
    @"祇園,2,2,2,2,2,2,2,3,3,3,3,3,1,1,1,1,1,1,1,1",
    @"四条京阪前,2,2,2,2,2,2,3,3,3,3,3,3,3,1,1,1,1,1,1",
    @"北野白梅町,4,5,5,5,5,5,5,5,3,3,3,3,2,2,2,1,1,1,1,1,1,1,1,1,1,6",
    @"西大路四条,1,1,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,6,3,3,3,3,3,3,3,2,2,2,5,5,5,5,4,4,4,4,4,4,4",
    @"金閣寺前,4,4,5,5",
    @"金閣寺道,3,3,3,3,3,3,3,1,1,1,1,1,2,2",
    @"銀閣寺前,o,o",
    @"銀閣寺道,1,2,2,4,4,4,4,4,4,3,3,3",
    @"千本今出川,1,1,1,1,1,1,4,4,4,4,4,4,4,5,5,5,5,3,3,2,2,2,2,2",
    @"河原町今出川,4,4,4,4,2,2,2,2,2,2,3,3,3,1,1,1,1,1,5",
    @"河原町三条,D,D,D,C,C,B,B,B,A,A,A,A,H,H,H,H,G,G,F,F,E,E",
    @"京都市役所前,C,C,B,A,A,A,A,A,A,A,A,D,D,D,D,D,D,D,D",
    @"二条駅前,A,A,A,A,A,A,A,A,A,B,B,B,B,B,B,B,B,B",
    @"西ノ京円町,2,2,2,2,4,4,5,5,5,5,5,5,5,5,5,3,3,3,1,1,1,1,1",
    @"太秦天神川駅前,C,A,A,A,A,A,A,A,A,B,B,B,B,B,B",
    ];
}

-(id)init
{
    self = [super init];
    if( self != nil )
    {
        [self initializeDefaultDataList];
        return self;
    }
    
    return nil;
}

-(void)removeAll
{
    [self.masterList removeAllObjects];
}

-(unsigned)countOfList
{
    unsigned n = [self.masterList count];
    if( 0 < n ) n += 2;
    
    return n;
}

- (PickupBus *)objectInListAtIndex:(unsigned)theIndex
{
    return [self.masterList objectAtIndex:theIndex];
}


- (void)addPickupBusWithNo:(NSString *)no destName:(NSString *)dest subName:(NSString *)sub html:(NSString *)html
{
    PickupBus *bus = [[PickupBus alloc] initWithNo:no destName:dest subName:sub html:html];
    [self.masterList addObject:bus];
}

- (void)addNoteDataFromBusstop:(NSString *)busstop
{
    for (NSString *line in db)
    {
        NSArray *a = [line componentsSeparatedByString:@","];
        if( [busstop isEqualToString:[a objectAtIndex:0]] == NO ) continue;
        
        NSUInteger i = 1;
        for (PickupBus *bus in self.masterList)
        {
            bus.note = [a objectAtIndex:i++];
        }
        
        break;
    }
}

@end
