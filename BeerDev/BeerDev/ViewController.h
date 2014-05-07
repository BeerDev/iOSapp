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
#import "ViewInformationController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate , UISearchDisplayDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIViewController *omOssController;
@property (strong, nonatomic) UIViewController *omKistanController;
@property (strong, nonatomic) UIViewController *categoryController;
@property (strong, nonatomic) UIViewController *ListController;
@property (strong,nonatomic) ViewInformationController * informationController;

@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UISearchBar *OursearchBar;

@property (strong, nonatomic) NSArray *JsonDataArray;
@property (strong, nonatomic) NSArray *ForSearchArray;

@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *dropButton;
@property (strong, nonatomic) UIButton *cancelSearch;

@property float contentOffsetInPage;

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;
+(BOOL)restartCache:(bool)forCache;

@end
