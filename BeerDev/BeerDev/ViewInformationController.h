//
//  ViewInformationController.h
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewInformationController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *artikelnamn;
@property (weak, nonatomic) IBOutlet UILabel *pris;
@property (weak, nonatomic) IBOutlet UILabel *info;

@property NSUInteger pageIndex;
@property NSString* name;
@property NSString* information;
@property NSString* SEK;




@end
