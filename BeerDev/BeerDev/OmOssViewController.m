//
//  OmOssViewController.m
//  BeerDev
//
//  Created by Emma Ström on 2014-04-29.
//  Copyright (c) 2014 beerDev. All rights reserved.
//
#import "OmOssViewController.h"

@interface OmOssViewController (){
    NSInteger Ycord;
    UIScrollView * scrollView;
    UIButton *facebookButton;

}

@end

@implementation OmOssViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view  addSubview:scrollView];
    [scrollView setScrollEnabled:YES];
    [self createOmOss];
    [self createButton];
    
}

 -(void)createOmOss{
     UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 50)];
     headLabel.text = @"BeerDev";
     headLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
     headLabel.shadowColor =[UIColor blackColor];
     headLabel.shadowOffset = CGSizeMake(1, 1);
     headLabel.textColor = [UIColor whiteColor];
     headLabel.textAlignment = NSTextAlignmentCenter;
     [scrollView addSubview:headLabel];
     Ycord = Ycord + 50;
     scrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + 50);
     
     
     
     UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 400)];
     bodyLabel.text = @"Applikationen är skapad av BeerDev, en projektgrupp bestående av 9 KTH studenter. Appen skapades i en IT-projektkurs under våren 2014 och finns både till iOS och Android. \n\nVi som har skapat applikationen är Maxim Frisk, Anne Golinski, Joakim Larsson, Jesper Nowak, Lina Poon, Christopher State, Patrik Stigeborn, Emma Ström och Jonathan Strömgren. \n\nApplikationen är skapad för att få en överblick över ölutbudet i Kistan. ";
     bodyLabel.numberOfLines = 0;
     bodyLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
     bodyLabel.shadowColor =[UIColor blackColor];
     bodyLabel.shadowOffset = CGSizeMake(1, 1);
     bodyLabel.textColor = [UIColor whiteColor];
     bodyLabel.textAlignment = NSTextAlignmentLeft;
         [bodyLabel sizeToFit];
     [scrollView addSubview:bodyLabel];
     Ycord = Ycord + bodyLabel.frame.size.height + 20;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + 50);
}

-(void)createButton{
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setFrame:CGRectMake(self.view.frame.size.width/2-52.5, Ycord, 105, 35)];
    [facebookButton setImage: [UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(showfacebook:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:facebookButton];
    Ycord = Ycord + facebookButton.frame.size.height + 20;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + 50);


}

-(void)showfacebook:(id)sender{
    NSURL *fbURL = [[NSURL alloc] initWithString:@"fb://profile/229588483907154"];
    // check if app is installed
    if ( ! [[UIApplication sharedApplication] canOpenURL:fbURL] ) {
        // if we get here, we can't open the FB app.
        fbURL = [NSURL URLWithString:@"http://facebook.com/beerdev"]; // direct URL on FB website to open in safari
    }
    
    [[UIApplication sharedApplication] openURL:fbURL];
}

@end
