//
//  ViewInformationController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewInformationController.h"

@interface ViewInformationController ()

@end

@implementation ViewInformationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //[[UIColor alloc] initWithHue:0 saturation:0 brightness:0 alpha:0.45];

    
    
    //här tar vi emot alla värden som ska visar. Dessa ställs in i pagecontentcontroller klassen när man "swipar" uppåt.
    self.artikelnamn.text = _name;
    self.pris.text = [[NSString alloc]initWithFormat:@"%@ kr*", _SEK];
    self.info.text = _information;
    self.proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", _pro];
    self.sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", _size];
    
    // Do any additional setup after loading the view.
}

@end
