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
    UIScrollView * AboutscrollView;
}

@end

@implementation OmKistanViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    AboutscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70)];
    AboutscrollView.backgroundColor = [UIColor clearColor];
    AboutscrollView.showsHorizontalScrollIndicator = NO;
    AboutscrollView.showsVerticalScrollIndicator = YES;
    [AboutscrollView setShowsVerticalScrollIndicator:NO];
    [AboutscrollView setShowsHorizontalScrollIndicator:NO];
    AboutscrollView.contentSize = CGSizeMake(100,110);
    [self.view  addSubview:AboutscrollView];
    [AboutscrollView setScrollEnabled:YES];
    [self createOmKistan];
}
-(void)createOmKistan{
    Ycord = 0;
    [self createHead:@"Kistan"];
    [self createBody:@"Kistan är INsektionens sektionslokal belägen i Kista. Med sina cirka 120 olika sorters öl är Kistan en av Stockholms mest välsorterade sektionslokaler gällande ölutbud.\n\nKistan är vanligtvis öppen på tisdagar och torsdagar med sektionens mästerier bakom baren. Även på vissa fredagar kan en pubkväll smyga sig in. \n\nKistans breda sortiment består av allt från vardagliga öltyper så som Ale, Lager, Pilsner till det lite mera ovanliga så som Trappis/Abbey, Lambik, Barley Wine och Saison. Givetvis finns även alkoholfri öl. \n\nKistans konstbeklädda väggar skapar en gemytlig känsla i din mage, dem matchas ihop bra med en tydlig eftersmak av hemtrevlighet och gemensak.\n\n*Observera att alla priser gälller medlemmar i INsektionen."];
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
    [AboutscrollView addSubview:headLabel];
    Ycord = Ycord + 50;
    AboutscrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + 50);
}

-(void)createBody:(NSString *)body{
    UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 300)];
    bodyLabel.text = body;
    bodyLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    bodyLabel.shadowColor =[UIColor blackColor];
    bodyLabel.shadowOffset = CGSizeMake(1, 1);
    bodyLabel.textColor = [UIColor whiteColor];
    bodyLabel.textAlignment = NSTextAlignmentLeft;
    bodyLabel.numberOfLines = 0;
    [bodyLabel sizeToFit];
    [AboutscrollView addSubview:bodyLabel];
    Ycord = Ycord + bodyLabel.frame.size.height + 20;
    AboutscrollView.contentSize = CGSizeMake(self.view.frame.size.width, Ycord + 50);
}


@end
