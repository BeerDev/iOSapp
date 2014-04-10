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
    
    
    
    
    //här tar vi emot alla värden som ska visar. Dessa ställs in i pagecontentcontroller klassen när man "swipar" uppåt.
    self.artikelnamn.text = _name;
    self.pris.text = [[NSString alloc]initWithFormat:@"%@ kr*", _SEK];
    self.info.text = _information;
    self.proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", _pro];
    self.sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ cl", _size];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
