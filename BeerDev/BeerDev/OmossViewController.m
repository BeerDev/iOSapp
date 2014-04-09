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
    
    //anropa funktioner här
    // Do any additional setup after loading the view.
}
- (IBAction)MailButton:(id)sender
{
    
    NSString *recipients = @"mailto:beerdev@gmail.com?cc=second@example.com&subject=BeerDev Application";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:recipients]];
    
}


@end
