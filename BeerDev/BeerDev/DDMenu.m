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
        menuSize = 320;
        
        Galleri = [UIImage imageNamed:@"Galleri"];
        Lista = [UIImage imageNamed:@"Lista"];
        Oltyper = [UIImage imageNamed:@"Oltyper"];
        Kistan = [UIImage imageNamed:@"Kistan"];
        Utvecklare = [UIImage imageNamed:@"Utvecklare"];
        
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55]];
        int correction = 30;
        
        /* 
         alphabeticSort.titleLabel.font = [UIFont systemFontOfSize:20];
         [alphabeticSort setImage:AZ forState:UIControlStateNormal];
         [alphabeticSort setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
         alphabeticSort.titleLabel.shadowOffset = CGSizeMake(1, 1);
         
         // [alphabeticSort setTitle:@"A - Ö" forState:UIControlStateNormal];
         [alphabeticSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [alphabeticSort addTarget:self action:@selector(sortAlphabetically) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:alphabeticSort];
         */
        
       // self.backgroundColor = [UIColor blackColor];
        //self.alpha = 0.6;
        if(self.frame.size.height == 480){
            correction = 0;
            
        }
        NSLog(@"%f",self.frame.size.height);

        _productViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productViewButton setImage:Galleri forState:UIControlStateNormal];
        self.productViewButton.frame = CGRectMake((self.frame.size.width/2)-75, 80+correction, 100, 100);
        [self addSubview:_productViewButton];
        

        _listViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listViewButton setImage:Lista forState:UIControlStateNormal];
        self.listViewButton.frame = CGRectMake((self.frame.size.width/2)+75, 80+correction, 100, 100);
        [self addSubview:_listViewButton];
        
        _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_categoryButton setImage:Oltyper forState:UIControlStateNormal];
        self.categoryButton.frame = CGRectMake((self.frame.size.width/2)-75, 210+correction, 100, 100);
        [self addSubview:_categoryButton];
        
        
        _omKistanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_omKistanButton setImage:Kistan forState:UIControlStateNormal];
        self.omKistanButton.frame = CGRectMake((self.frame.size.width/2)+75, 210+correction, 100, 100);
        [self addSubview:_omKistanButton];
        
        _omOssButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_omOssButton setImage:Utvecklare forState:UIControlStateNormal];
        self.omOssButton.frame = CGRectMake((self.frame.size.width/2), 340+correction, 100, 100);
        [self addSubview:_omOssButton];
    }
    return self;
}

-(void)DropDownMenu:(float)phoneWidth{

    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(phoneWidth-menuSize, 0,  menuSize, self.frame.size.height);
    } completion:^(BOOL finished) {
        NSLog(@"Drop");
    }];
}

-(void)HideDownMenu:(float)phoneWidth{
    NSLog(@"Hide");
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(phoneWidth+menuSize, 0,  menuSize, self.frame.size.height);
        
    }];
}

@end
