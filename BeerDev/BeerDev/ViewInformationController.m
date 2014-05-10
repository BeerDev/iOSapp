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
    UITextView *infoLabel;
    
    UIImageView* symbol;
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
    [self createLable];
    [self setSymbol];
}
-(void)changeTextByIndex{
    JsonDataArray =  _arrayFromViewController;
    NSInteger rightIndex = _pageIndex;
    
    brewLabel.text= [JsonDataArray[rightIndex] objectForKey:@"Bryggeri"];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", [JsonDataArray[rightIndex] objectForKey:@"Storlek"]];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", [JsonDataArray[rightIndex] objectForKey:@"Utpris"]];
    nameLabel.text= [JsonDataArray[rightIndex]objectForKey:@"Artikelnamn"];
    typeLabel.text =[JsonDataArray[rightIndex] objectForKey:@"Kategori"];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", [JsonDataArray[rightIndex] objectForKey:@"Alkoholhalt"]];
    
    infoLabel.text =[JsonDataArray[rightIndex] objectForKey:@"Info"];

}

-(void)createLable{
    //Skapa namnlabel
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, self.view.frame.size.width-30, 50)];
    nameLabel.text=[JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
    [self labelTemplet:nameLabel];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:25];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    [self.view addSubview:nameLabel];
    
    // Create brewery label.
    brewLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, self.view.frame.size.width-30, 50)];
    brewLabel.text=[JsonDataArray[_pageIndex] objectForKey:@"Bryggeri"];
    [self labelTemplet:brewLabel];
    brewLabel.textAlignment = NSTextAlignmentCenter;
    brewLabel.adjustsFontSizeToFitWidth = YES;
    brewLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    [self.view addSubview:brewLabel];
    
    // Create size label.
    sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, self.view.frame.size.width-40, 50)];
    sizeLabel.text = [[NSString alloc]initWithFormat:@"%@ ml", [JsonDataArray[_pageIndex] objectForKey:@"Storlek"]];
    sizeLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    sizeLabel.textAlignment = NSTextAlignmentLeft;
    [self labelTemplet:sizeLabel];
    
    [self.view addSubview:sizeLabel];
   
    // Create price label.
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, self.view.frame.size.width-40, 50)];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", [JsonDataArray[_pageIndex] objectForKey:@"Utpris"]];
    [self labelTemplet:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    [self.view addSubview:priceLabel];
    
    // Create type label.
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, self.view.frame.size.width-40, 50)];
    typeLabel.text =[JsonDataArray[_pageIndex] objectForKey:@"Kategori"];
    [self labelTemplet:typeLabel];
    typeLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:typeLabel];
    
    // Create % label.
    proLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, self.view.frame.size.width-40, 50)];
    proLabel.text = [[NSString alloc]initWithFormat:@"%@ %%", [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"]];
    [self labelTemplet:proLabel];
    proLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    proLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:proLabel];
    
    // Create information label.
    infoLabel = [[UITextView alloc] init];
    infoLabel.frame = CGRectMake(20, 225, self.view.frame.size.width-40,300);
    infoLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.text =[JsonDataArray[_pageIndex] objectForKey:@"Info"];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.userInteractionEnabled = NO;
    infoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:infoLabel];
}

-(void)labelTemplet:(UILabel *)label{
    // Skapa Templet
    label.textColor = [UIColor whiteColor];
    label.shadowColor =[UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1) ;

}

-(void)setSymbol{
    symbol = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noArrow"]];
    symbol.frame = CGRectMake(self.view.frame.size.width/2-18, 55,36, 11);
    symbol.alpha = 0.7;
    [self.view addSubview:symbol];
}

-(void)changeSymbolToArrow{
    symbol.image = [UIImage imageNamed:@"arrowDown"];
}
-(void)changeSymbolBack{
    symbol.image = [UIImage imageNamed:@"noArrow"];
}

@end
