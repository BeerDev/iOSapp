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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view.
    [self createLable];
}

-(void)labelTemplet:(UILabel *)label
{
    // Skapa Templet
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
    label.textColor = [UIColor whiteColor];
    label.shadowColor =[UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1) ;
    label.textAlignment = NSTextAlignmentLeft;
}

-(void)createLable
{
    Ycord = self.view.frame.size.height*1;
    //NSLog(@"%ld",(long)Ycord);
    
    //Skapa namnlabel
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.16, self.view.frame.size.width-40, 50)];
    nameLabel.text=_name;
    [self labelTemplet:nameLabel];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 2;
    //[nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    //Skapa bryggerilable
    UILabel *brewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.21, self.view.frame.size.width-40, 50)];
    brewLabel.text=_brygg;
    [self labelTemplet:brewLabel];
    brewLabel.textAlignment = NSTextAlignmentCenter;
    brewLabel.adjustsFontSizeToFitWidth = YES;
    brewLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    [self.view addSubview:brewLabel];
    
    //Skapa storlekLabel
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.31, self.view.frame.size.width-40, 50)];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", _size];
    [self labelTemplet:sizeLabel];
    [self.view addSubview:sizeLabel];
    
    //Skapa prisLabel
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.31, self.view.frame.size.width-40, 50)];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", _SEK];
    [self labelTemplet:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:priceLabel];
    
    //Skapa typLabel
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.39, self.view.frame.size.width-40, 50)];
    typeLabel.text =_kategori;
    [self labelTemplet:typeLabel];
    [self.view addSubview:typeLabel];
    
    //Skapa procentLabel
    UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.39, self.view.frame.size.width-40, 50)];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", _pro];
    [self labelTemplet:proLabel];
    proLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:proLabel];
    
    //Skapa informationlable
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord*0.51, self.view.frame.size.width-40, 50)];
    infoLabel.text =_information;
    [self labelTemplet:infoLabel];
    infoLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];
    [self.view addSubview:infoLabel];
}

@end
