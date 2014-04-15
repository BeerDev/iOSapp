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
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.35]];
        
        
        _productView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_productView setTitle:@"Produkt info" forState:UIControlStateNormal];
        _productView.titleLabel.font = [UIFont systemFontOfSize:24];
        _productView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_productView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.productView.frame = CGRectMake(0, 70, self.frame.size.width-10, 50);
        NSLog(@"did we get here?");
        [self addSubview:_productView];
        
        _listView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_listView setTitle:@"Lista på öl" forState:UIControlStateNormal];
        _listView.titleLabel.font = [UIFont systemFontOfSize:24];
        _listView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_listView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.listView.frame = CGRectMake(0, 120, self.frame.size.width-10, 50);
        
        [self addSubview:_listView];
        
        
        _omOss = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_omOss setTitle:@"Om oss" forState:UIControlStateNormal];
        _omOss.titleLabel.font = [UIFont systemFontOfSize:24];
        _omOss.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_omOss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.omOss.frame = CGRectMake(0, 170, self.frame.size.width-10, 50);
        
        [self addSubview:_omOss];
        

        
//[self SetButtons];
        
        
/*

 
 */
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

-(void)SetButtons{
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
