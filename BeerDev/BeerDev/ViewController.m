//
//  ViewController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-03-28.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    //declare variables here to be global through this class
    BOOL button;
    UIButton* dropButton;
    DDMenu*menu;
    BOOL about;
    BOOL list;
    BOOL product;
}
@end
@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    
    //create omOssController
    self.omOssController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmossViewController"];
    self.omOssController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omOssController willMoveToParentViewController:self];
    [self addChildViewController:self.omOssController];
    
    // Create listcontroller
    self.ListController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    self.ListController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.ListController willMoveToParentViewController:self];
    [self addChildViewController:self.ListController];

    // Create PageViewController
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    //[jsonData SetIndex:0];
    //Start the page view controller with this first page at index 0;
    PageContentViewController *startingViewController = [self viewControllerAtIndex:[jsonData GetIndex]];
    NSArray *viewControllers = @[startingViewController];
    
    //set the PageViewController by storyboard ID.
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller if needed.
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Set page that is showing
    product = YES;
    
    // menu and buttons
    [self setButton];
    menu = [[DDMenu alloc ]initWithFrame:CGRectMake(0, -220, self.view.frame.size.width, 220)];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:dropButton];

    
}

- (void)switchTo:(UIViewController*)from to:(UIViewController *)controller
{
    
    [self transitionFromViewController:from
                      toViewController: controller
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                          // no animation necessary, but docs say this can't be NULL
                            }
                            completion:^(BOOL finished){
                                [menu HideDownMenu];
                                NSLog(@"you switched");
            }];
}

-(void)setButton{
    button = NO;
    dropButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    dropButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [dropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dropButton.frame = CGRectMake(self.view.frame.size.width-44, 20, 50, 50);
    [dropButton addTarget:self action:@selector(DropMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dropButton];

}

-(void)DropMenu{
    if(button == NO){
        [menu DropDownMenu];
        [dropButton setTitle:@"▲" forState:UIControlStateNormal];
        
        [[menu omOssButton] addTarget:self action:@selector(GoToOmOss) forControlEvents:UIControlEventTouchUpInside];
        [[menu productViewButton] addTarget:self action:@selector(GoToProductInfo) forControlEvents:UIControlEventTouchUpInside];
        [[menu listViewButton] addTarget:self action:@selector(GoToList) forControlEvents:UIControlEventTouchUpInside];

        button = YES;
    }
    else if (button == YES){
        [menu HideDownMenu];
        [dropButton setTitle:@"▼" forState:UIControlStateNormal];
         button = NO;
    }
}


-(void)GoToProductInfo{
    if (about == YES) {
        about = NO;
        product = YES;
        [self switchTo:self.omOssController to:self.pageViewController];
        [self menuBarToFront];
    }
    else if (list == YES){
        list = NO;
        product = YES;
        [self switchTo:self.ListController to:self.pageViewController];
        [self menuBarToFront];
    }else{
        [menu HideDownMenu];
        [dropButton setTitle:@"▼" forState:UIControlStateNormal];
        button = NO;
    }
}

-(void)GoToList{
    if (about == YES) {
        about = NO;
        list = YES;
        [self switchTo:self.omOssController to:self.ListController];
        [self menuBarToFront];
    }
    else if (product == YES){
        product = NO;
        list = YES;
        [self switchTo:self.pageViewController to:self.ListController];
        [self menuBarToFront];
    }
    else
    {
    [menu HideDownMenu];
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
    }
   
    
}


-(void)GoToOmOss{
    if (list == YES) {
        list = NO;
        about = YES;
        [self switchTo:self.ListController to:self.omOssController];
        [self menuBarToFront];
    }
    else if (product == YES){
        product = NO;
        about= YES;
        [self switchTo:self.pageViewController to:self.omOssController];
        [self menuBarToFront];
    }else
    {
    [menu HideDownMenu];
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
    }
}


-(void)menuBarToFront{
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:dropButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark PageViewController 
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([[jsonData GetArray] count] == 0) ||( index >= [[jsonData GetArray] count])) {
        return nil;
    }
   // NSLog(@"%d",[[jsonData GetArray] count]);
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
 
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [[jsonData GetArray] count]-1) {
        return nil;
    }
  
    return [self viewControllerAtIndex:index];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}



/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [[jsonData GetArray] count]-1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
*/

@end
