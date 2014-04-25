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
        
        [_productViewButton setTitle:@"Visa öl" forState:UIControlStateNormal];
        _productViewButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _productViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_productViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.productViewButton.frame = CGRectMake(0, 50, self.frame.size.width-10, 40);
        
        [self addSubview:_productViewButton];
        
        _listViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_listViewButton setTitle:@"Lista öl" forState:UIControlStateNormal];
        _listViewButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _listViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_listViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.listViewButton.frame = CGRectMake(0, 80, self.frame.size.width-10, 40);
        
        [self addSubview:_listViewButton];
        
        _categoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_categoryButton setTitle:@"Typ" forState:UIControlStateNormal];
        _categoryButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _categoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_categoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.categoryButton.frame = CGRectMake(0, 110, self.frame.size.width-10, 40);
        [self addSubview:_categoryButton];
        
        
        _omKistanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_omKistanButton setTitle:@"Om Kistan" forState:UIControlStateNormal];
        _omKistanButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _omKistanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_omKistanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.omKistanButton.frame = CGRectMake(0, 140, self.frame.size.width-10, 40);
        [self addSubview:_omKistanButton];
        
        _omOssButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_omOssButton setTitle:@"Om BeerDev" forState:UIControlStateNormal];
        _omOssButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _omOssButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_omOssButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.omOssButton.frame = CGRectMake(0, 170, self.frame.size.width-10, 40);
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
