//
//  DDMenu.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-14.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "DDMenu.h"

@implementation DDMenu

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        // Initialization code
        
        menuSize = 320;
        Galleri = [UIImage imageNamed:@"Galleri"];
        Lista = [UIImage imageNamed:@"Lista"];
        Oltyper = [UIImage imageNamed:@"Oltyper"];
        Kistan = [UIImage imageNamed:@"Kistan"];
        Utvecklare = [UIImage imageNamed:@"Utvecklare"];
        barcode = [UIImage imageNamed:@"barscan"];
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.55]];
        int correction = 30;
        
        if(self.frame.size.height == 480){
            correction = 0;
        }
        _productViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _productViewButton.tag = 0;
        _productViewButton.exclusiveTouch = YES;
        [_productViewButton setImage:Galleri forState:UIControlStateNormal];
        self.productViewButton.frame = CGRectMake((self.frame.size.width/2)-75, 80+correction, 100, 100);
        [self addSubview:_productViewButton];
        
        _listViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _listViewButton.tag = 1;
        _listViewButton.exclusiveTouch = YES;
        [_listViewButton setImage:Lista forState:UIControlStateNormal];
        self.listViewButton.frame = CGRectMake((self.frame.size.width/2)+75, 80+correction, 100, 100);
        [self addSubview:_listViewButton];
        
        _barcodeScan = [UIButton buttonWithType:UIButtonTypeCustom];
        _barcodeScan.tag = 5;
        _barcodeScan.exclusiveTouch = YES;
        [_barcodeScan setImage:barcode forState:UIControlStateNormal];
        self.barcodeScan.frame = CGRectMake((self.frame.size.width/2)-75, 210+correction, 100, 100);
        [self addSubview:_barcodeScan];
        
        
        _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _categoryButton.tag = 2;
        _categoryButton.exclusiveTouch = YES;
        [_categoryButton setImage:Oltyper forState:UIControlStateNormal];
        self.categoryButton.frame = CGRectMake((self.frame.size.width/2)+75, 210+correction, 100, 100);
        [self addSubview:_categoryButton];
        
        _omKistanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _omKistanButton.tag = 3;
        _omKistanButton.exclusiveTouch = YES;
        [_omKistanButton setImage:Kistan forState:UIControlStateNormal];
        self.omKistanButton.frame = CGRectMake((self.frame.size.width/2)+75, 340+correction, 100, 100);
        [self addSubview:_omKistanButton];
        
        _omOssButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _omOssButton.tag = 4;
        _omOssButton.exclusiveTouch = YES;
        [_omOssButton setImage:Utvecklare forState:UIControlStateNormal];
        self.omOssButton.frame = CGRectMake((self.frame.size.width/2)-75, 340+correction, 100, 100);
        [self addSubview:_omOssButton];
    }
    return self;
}


-(void)DropDownMenu:(float)phoneWidth{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(phoneWidth-menuSize, 0,  menuSize, self.frame.size.height);
    }
        completion:^(BOOL finished) {
        }];
}

-(void)HideDownMenu:(float)phoneWidth{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(phoneWidth+menuSize, 0,  menuSize, self.frame.size.height);
    }];
}
-(void)HideDownMenuWithStyle:(float)phoneWidth xCord:(float)xTarget{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(xTarget, 0,  menuSize, self.frame.size.height);
        }];
}

@end
