//
//  DDMenu.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-14.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "DDMenu.h"

@implementation DDMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        menuSize = 220;
        
       // self.backgroundColor = [UIColor blackColor];
        //self.alpha = 0.6;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.45]];
        
        _productViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_productViewButton setTitle:@"Visa Öl" forState:UIControlStateNormal];
        _productViewButton.titleLabel.font = [UIFont systemFontOfSize:24];
        _productViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_productViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.productViewButton.frame = CGRectMake(0, 70, self.frame.size.width-10, 50);
        
        [self addSubview:_productViewButton];
        
        _listViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_listViewButton setTitle:@"Lista All Öl" forState:UIControlStateNormal];
        _listViewButton.titleLabel.font = [UIFont systemFontOfSize:24];
        _listViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_listViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.listViewButton.frame = CGRectMake(0, 120, self.frame.size.width-10, 50);
        
        [self addSubview:_listViewButton];

        _omOssButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_omOssButton setTitle:@"Om Oss" forState:UIControlStateNormal];
        _omOssButton.titleLabel.font = [UIFont systemFontOfSize:24];
        _omOssButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_omOssButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.omOssButton.frame = CGRectMake(0, 170, self.frame.size.width-10, 50);
        [self addSubview:_omOssButton];
    }
    return self;
}

-(void)DropDownMenu{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0,  self.frame.size.width, menuSize);
    } completion:^(BOOL finished) {
        NSLog(@"Drop");
    }];
}

-(void)HideDownMenu{
    NSLog(@"Hide");
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, -menuSize,  self.frame.size.width, menuSize);
        
    }];
}

@end
