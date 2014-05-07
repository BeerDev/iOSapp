//
//  ViewInformationController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-09.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewInformationController.h"

@interface ViewInformationController (){
    NSArray * JsonDataArray;
    UILabel *nameLabel;
    UILabel *brewLabel;
    UILabel *sizeLabel;
    UILabel *priceLabel;
    UILabel *typeLabel;
    UILabel *proLabel;
    UILabel *infoLabel;
}

@end

@implementation ViewInformationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    JsonDataArray =  _arrayFromViewController;
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    [self createLable];
}
-(void)changeTextByIndex{
    JsonDataArray =  _arrayFromViewController;
    NSInteger rightIndex = _pageIndex;
    brewLabel.text= [JsonDataArray[rightIndex] objectForKey:@"Bryggeri"];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", [JsonDataArray[rightIndex] objectForKey:@"Storlek"]];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", [JsonDataArray[rightIndex] objectForKey:@"Utpris exkl moms"]];
    nameLabel.text= [JsonDataArray[rightIndex]objectForKey:@"Artikelnamn"];
    typeLabel.text =[JsonDataArray[rightIndex] objectForKey:@"Kategori"];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", [JsonDataArray[rightIndex] objectForKey:@"Alkoholhalt"]];
    infoLabel.text =[JsonDataArray[rightIndex] objectForKey:@"Info"];
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];
}


-(void)createLable{
    //Skapa namnlabel
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 77, self.view.frame.size.width-40, 50)];
    nameLabel.text=[JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
    [self labelTemplet:nameLabel];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    [self.view addSubview:nameLabel];
    
    // Create brewery label.
    brewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, self.view.frame.size.width-40, 50)];
    brewLabel.text=[JsonDataArray[_pageIndex] objectForKey:@"Bryggeri"];
    [self labelTemplet:brewLabel];
    brewLabel.textAlignment = NSTextAlignmentCenter;
    brewLabel.adjustsFontSizeToFitWidth = YES;
    brewLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    [self.view addSubview:brewLabel];
    
    // Create size label.
    sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width-40, 50)];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", [JsonDataArray[_pageIndex] objectForKey:@"Storlek"]];
    [self labelTemplet:sizeLabel];
    [self.view addSubview:sizeLabel];
   
    // Create price label.
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width-40, 50)];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"]];
    [self labelTemplet:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:priceLabel];
    
    // Create type label.
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, self.view.frame.size.width-40, 50)];
    typeLabel.text =[JsonDataArray[_pageIndex] objectForKey:@"Kategori"];
    [self labelTemplet:typeLabel];
    [self.view addSubview:typeLabel];
    
    // Create % label.
    proLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, self.view.frame.size.width-40, 50)];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"]];
    [self labelTemplet:proLabel];
    proLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:proLabel];
    
    // Create information label.
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, self.view.frame.size.width-40,240)];
    infoLabel.text =[JsonDataArray[_pageIndex] objectForKey:@"Info"];
    [self labelTemplet:infoLabel];
    infoLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
  //infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.numberOfLines = 0;
    [infoLabel sizeToFit];

    [self.view addSubview:infoLabel];
}

-(void)labelTemplet:(UILabel *)label{
    // Skapa Templet
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    label.textColor = [UIColor whiteColor];
    label.shadowColor =[UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1) ;
    label.textAlignment = NSTextAlignmentLeft;
}

@end
