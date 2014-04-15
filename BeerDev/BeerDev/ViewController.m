//
//  ViewController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-03-28.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    //declare variables here to be global thru this class
    PageContentViewController *pageContentViewController;
    PageContentViewController *startingViewController;
    BOOL button;
    UIButton* dropButton;
    UIButton* omOss;
    DDMenu*menu;
}
@end
@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    
    //create om oss
    
    self.omOssController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmossViewController"];
    self.omOssController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_omOssController];

    
    // Create PageViewController
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    //[jsonData SetIndex:0];
    //Start the page view controller with this first page at index 0;
    startingViewController = [self viewControllerAtIndex:[jsonData GetIndex]];
    NSArray *viewControllers = @[startingViewController];
    
    //set the PageViewController by storyboard ID.
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller if needed.
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    [self setButton];

    
    menu = [[DDMenu alloc ]initWithFrame:CGRectMake(0, -170, self.view.frame.size.width, 170)];
    [self.view addSubview:menu];
    

    [self.view bringSubviewToFront:dropButton];

    
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
        
        [[menu omOss] addTarget:self action:@selector(GoToOmOss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:omOss];
        button = YES;
    }
    else if (button == YES){
        [menu HideDownMenu];
        [dropButton setTitle:@"▼" forState:UIControlStateNormal];
         button = NO;
    }
}
-(void)HideMenu{

}

-(void)GoToOmOss{
    [self.pageViewController willMoveToParentViewController:nil];
    [self.pageViewController removeFromParentViewController];
    self.pageViewController = nil;

    [self.pageViewController willMoveToParentViewController:nil];
    [startingViewController removeFromParentViewController];
    startingViewController = nil;

    [self.pageViewController willMoveToParentViewController:nil];
    [pageContentViewController removeFromParentViewController];
    pageContentViewController = nil;

    
    [self.view addSubview:_omOssController.view];
    [self.omOssController didMoveToParentViewController:self];
    [self menuBarChange];
    
}


-(void)menuBarChange{
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:dropButton];
    [menu HideDownMenu];
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
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
    pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
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
