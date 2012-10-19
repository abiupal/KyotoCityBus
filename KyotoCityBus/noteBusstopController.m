//
//  noteBusstopController.m
//  KyotoCityBus
//
//  Created by 武村 健二 on 2012/08/14.
//  Copyright (c) 2012年 wHITEgODDESS. All rights reserved.
//

#import "noteBusstopController.h"

@implementation NoteBusstopController

@synthesize imgView = _imgView;
@synthesize image = _image;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.imgView setImage:self.image];
}


@end
