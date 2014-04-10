//
//  OmossViewController.m
//  BeerDev
//
//  Created by Jesper Nowak on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "OmossViewController.h"

@interface OmossViewController ()

@end

@implementation OmossViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
