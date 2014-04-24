//
//  ViewController.h
//  BeerDev
//
//  Created by Maxim Frisk on 2014-03-28.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jsonData.h"
#import "PageContentViewController.h"
#import "DDMenu.h"
#import "UIResponderKeyboardCache.h"



@interface ViewController : UIViewController <UIPageViewControllerDataSource,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIViewController *omOssController;
@property (strong, nonatomic) UIViewController * ListController;


@end
