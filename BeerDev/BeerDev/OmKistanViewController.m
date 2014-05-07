//
//  AboutPageViewController.m
//  BeerDev
//
//  Created by Emma Ström on 2014-04-29.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "OmKistanViewController.h"

@interface OmKistanViewController (){
    NSInteger Ycord;
    UIScrollView * scrollView;
}

@end

@implementation OmKistanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    [self createOmKistan];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createOmKistan{
    Ycord = 0;
    [self createHead:@"Kistan"];
    [self createBody:@"Kistan är INsektionens sektionslokal belägen i Kista. Med sina cirka 120 olika sorters öl är Kistan en av Stockholms mest välsorterade sektionslokaler gällande ölutbud.\n\n Kistan är vanligtvis öppen på tisdagar och torsdagar med sektionens mästerier bakom baren. Även på vissa fredagar kan en pubkväll smyga sig in. \n\n Kistans breda sortiment består av allt från vardagliga öltyper så som Ale, Lager, Pilsner till det lite mera ovanliga så som Trappis/Abbey, Lambik, Barley Wine och Saison. Givetvis finns även alkoholfri öl. \n\n Kistans konstbeklädda väggar skapar en gemytlig känsla i din mage, dem matchas ihop bra med en tydlig eftersmak av hemtrevlighet och gemensak.\n\n\n *Observera att alla priser gälller medlemmar i INsektionen."];
    //[self createContact:@"BeerDevelopment@gmail.com"];
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
    bodyLabel.textAlignment = NSTextAlignmentLeft;
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
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + contactLabel.frame.size.height + 50);
}

@end
