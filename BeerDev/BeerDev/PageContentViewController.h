//
//  PageContentViewController.h
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-04.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jsonData.h"
#import "ViewInformationController.h"

@interface PageContentViewController : UIViewController

//image for the product
@property (strong, nonatomic) IBOutlet UIImageView *displayImage;
//label for the name of the product
@property (weak, nonatomic) IBOutlet UILabel *artikelnamnLabel;
//label for price
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//label for information
//@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) ViewInformationController* InformationController;
//this is used in pageViewController to track on what index you are at.
@property NSUInteger pageIndex;
//a bool to se if the information is showing or not.
@property BOOL informationIsShowing;


//connection functions from NSURLConnection. 
@property (nonatomic,retain) NSMutableArray* jsonObjects;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end
