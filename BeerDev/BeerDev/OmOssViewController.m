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
}

@end

@implementation OmOssViewController

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
    
    // Do any additional setup after loading the view.
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view  addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    [scrollView setScrollEnabled:YES];
    
    [self createOmOss];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 -(void)createOmOss{
     [self createHead:@"BeerDev"];
     [self createBody:@"Applikationen är skapad av BeerDev, en projektgrupp bestående av 9 KTH studenter. Appen skapades i en IT-projektkurs under våren 2014 och finns både till iOS och Android. \n\n Vi som har skapat applikationen är Maxim Frisk, Anne Golinski, Joakim Larsson, Jesper Nowak, Lina Poon, Christopher State, Patrik Stigeborn, Emma Ström och Jonathan Strömgren. \n\n Applikationen är skapad för att få en överblick över ölutbudet i Kistan. \n\n\n *Observera att alla priser gälller medlemmar i INsektionen. "];
     
    [self createContact:@"BeerDevelopment@gmail.com"];
     
 
 }

-(void)createHead:(NSString *)head{
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 50)];
    headLabel.text = head;
    headLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
    headLabel.shadowColor =[UIColor blackColor];
    headLabel.shadowOffset = CGSizeMake(1, 1);
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:headLabel];
    Ycord = Ycord + 50;
    
}

-(void)createBody:(NSString *)body{
    UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 200)];
    bodyLabel.text = body;
    bodyLabel.numberOfLines = 30;
    bodyLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    bodyLabel.shadowColor =[UIColor blackColor];
    bodyLabel.shadowOffset = CGSizeMake(1, 1);
    bodyLabel.textColor = [UIColor whiteColor];
    bodyLabel.textAlignment = NSTextAlignmentCenter;
    [bodyLabel sizeToFit];
    [scrollView addSubview:bodyLabel];
    Ycord = Ycord + bodyLabel.frame.size.height + 20;
}
-(void)createContact:(NSString *)contact{
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 50)];
    contactLabel.text = contact;
    contactLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
    contactLabel.shadowColor =[UIColor blackColor];
    contactLabel.shadowOffset = CGSizeMake(1, 1);
    contactLabel.textColor = [UIColor whiteColor];
    contactLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:contactLabel];
}

@end
