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
        menuSize = 170;
        
       // self.backgroundColor = [UIColor blackColor];
        //self.alpha = 0.6;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.35]];
        
        [self SetButtons];
        
        
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
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, -menuSize,  self.frame.size.width, menuSize);
        
    }];
}

-(void)SetButtons{
    _tableView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [_tableView setTitle:@"Lista all öl" forState:UIControlStateNormal];
    _tableView.titleLabel.font = [UIFont systemFontOfSize:24];
    _tableView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_tableView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.tableView.frame = CGRectMake(0, 70, self.frame.size.width-10, 50);
    
    [self addSubview:_tableView];
    
    
    _omOss = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [_omOss setTitle:@"Om oss" forState:UIControlStateNormal];
    _omOss.titleLabel.font = [UIFont systemFontOfSize:24];
    _omOss.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_omOss setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.omOss.frame = CGRectMake(0, 120, self.frame.size.width-10, 50);
    
    [self addSubview:_omOss];
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
