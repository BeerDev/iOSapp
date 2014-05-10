//
//  ViewInformationController.h
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewInformationController : UIViewController

@property NSArray *arrayFromViewController;
@property NSUInteger pageIndex;
-(void)changeTextByIndex;
-(void)changeSymbolToArrow;
-(void)changeSymbolBack;
@end
