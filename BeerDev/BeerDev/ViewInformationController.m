//
//  ViewInformationController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewInformationController.h"

@interface ViewInformationController (){
    NSInteger Ycord;
}

@end

@implementation ViewInformationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    [self createLable];
}

-(void)labelTemplet:(UILabel *)label{
    // Skapa Templet
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    label.textColor = [UIColor whiteColor];
    label.shadowColor =[UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1) ;
    label.textAlignment = NSTextAlignmentLeft;
}

-(void)createLable{
    //Skapa namnlabel
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.16, self.view.frame.size.width-40, 50)];
    nameLabel.text=_name;
    [self labelTemplet:nameLabel];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    [self.view addSubview:nameLabel];
    // Create brewery label.
    UILabel *brewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.16 + nameLabel.frame.size.height-20, self.view.frame.size.width-40, 50)];
    brewLabel.text=_brygg;
    [self labelTemplet:brewLabel];
    brewLabel.textAlignment = NSTextAlignmentCenter;
    brewLabel.adjustsFontSizeToFitWidth = YES;
    brewLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    [self.view addSubview:brewLabel];
    // Create size label.
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.31, self.view.frame.size.width-40, 50)];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", _size];
    [self labelTemplet:sizeLabel];
    [self.view addSubview:sizeLabel];
    // Create price label.
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.31, self.view.frame.size.width-40, 50)];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", _SEK];
    [self labelTemplet:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:priceLabel];
    // Create type label.
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.39, self.view.frame.size.width-40, 50)];
    typeLabel.text =_kategori;
    [self labelTemplet:typeLabel];
    [self.view addSubview:typeLabel];
    // Create % label.
    UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.39, self.view.frame.size.width-40, 50)];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", _pro];
    [self labelTemplet:proLabel];
    proLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:proLabel];
    // Create information label.
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.51, self.view.frame.size.width-40, 50)];
    infoLabel.text =_information;
    [self labelTemplet:infoLabel];
    infoLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];
    [self.view addSubview:infoLabel];
}

@end
