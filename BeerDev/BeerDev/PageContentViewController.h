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

// Image for the product.
@property (strong, nonatomic) IBOutlet UIImageView *displayImage;

@property (strong, nonatomic) ViewInformationController* InformationController;
// This is used in pageViewController to track on what index you are at.
@property NSUInteger pageIndex;
@property NSMutableArray *arrayFromViewController;
// A BOOL to se if the information is showing or not.
@property BOOL informationIsShowing;
// Connection functions from NSURLConnection.
@property (nonatomic,retain) NSMutableArray* jsonObjects;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end
