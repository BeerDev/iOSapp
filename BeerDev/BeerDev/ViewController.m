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
    UIButton* priceSort;
    UIButton* alphabeticSort;
    UIButton* searchButton;
    DDMenu*menu;
    BOOL about;
    BOOL list;
    BOOL product;
    BOOL ShowAlphabet;
    
    PageContentViewController *startingViewController;
    NSArray *viewControllers;
    NSArray *indexTitle;

    
    //table
    UITableView *ourTableView;
    
    //global variables table
    NSArray * JsonDataArray;

}
@end
@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];

    JsonDataArray = [jsonData GetArray];
    JsonDataArray = [self ourSortingFunction:@"Artikelnamn"];
    ShowAlphabet = YES;
    //create omOssController
    self.omOssController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmossViewController"];
    self.omOssController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omOssController willMoveToParentViewController:self];
    [self addChildViewController:self.omOssController];
    
    // Create listcontroller
    indexTitle = [NSArray arrayWithArray: [@"A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|Å|Ä|Ö" componentsSeparatedByString:@"|"]];
    
    self.ListController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    self.ListController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.ListController willMoveToParentViewController:self];
    [self addChildViewController:self.ListController];

    // Create PageViewController
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    //[jsonData SetIndex:0];

    // Change the size of page view controller if needed.
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Set page that is showing
    product = YES;
    //[jsonData SetIndex:1];
    [self goToPageIndex:0];
    
    // menu and buttons
    [self setButton];
    menu = [[DDMenu alloc ]initWithFrame:CGRectMake(0, -220, self.view.frame.size.width, 220)];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:dropButton];
    

    //Create a table
    ourTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70) ];
    [self.ListController.view addSubview:ourTableView];
    ourTableView.backgroundColor = [UIColor clearColor];
    ourTableView.showsVerticalScrollIndicator = YES;
    ourTableView.delegate = self;
    ourTableView.dataSource = self;
    ourTableView.separatorColor=[UIColor clearColor];
    ourTableView.showsVerticalScrollIndicator = UIScrollViewIndicatorStyleWhite;
    ourTableView.rowHeight = 70;
    
    [[UITableView appearance] setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
   // [[UITableView appearance] setSectionIndexTrackingBackgroundColor:[UIColor whiteColor]];
    [[UITableView appearance] setSectionIndexColor:[UIColor whiteColor]];
    
    [self createListButtons];
    //sort
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)searchInList{
    NSLog(@"searching... ");
}

#pragma mark - Switching between views.

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



#pragma mark - Buttons and menu

-(void)createListButtons{
    priceSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    priceSort.frame = CGRectMake(4, 20, 50, 50);
    priceSort.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [priceSort setTitle:@"$" forState:UIControlStateNormal];
    [priceSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceSort addTarget:self action:@selector(sortPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.ListController.view addSubview:priceSort];
    
    
    alphabeticSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alphabeticSort.frame = CGRectMake(64, 20, 50, 50);
    alphabeticSort.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [alphabeticSort setTitle:@"A - Ö" forState:UIControlStateNormal];
    [alphabeticSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alphabeticSort addTarget:self action:@selector(sortAlphabetically) forControlEvents:UIControlEventTouchUpInside];
    [self.ListController.view addSubview:alphabeticSort];
    
    UIImage *magnifier = [UIImage imageNamed:@"magnifier"];
    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(124, 20, 50, 50);
    
    [searchButton setImage:magnifier forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchInList)
           forControlEvents:UIControlEventTouchUpInside];
    
    float size = 35;
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(size, size, size, size)];
    [self.ListController.view addSubview:searchButton];
    
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

-(void)menuBarToFront{
    [dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:dropButton];
    
}

#pragma mark - Sorting indexs in tableView

-(void)sortAlphabetically{
    JsonDataArray = [self ourSortingFunction:@"Artikelnamn"];
    ShowAlphabet = YES;
    [ourTableView reloadData];
    
   
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;

}

-(void)sortPrice{
    JsonDataArray = [self ourSortingFunction:@"Utpris exkl moms"];
    ShowAlphabet = NO;
    [ourTableView reloadData];
    
 
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;
}

#pragma mark PageViewController 
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([JsonDataArray count] == 0) ||( index >= [JsonDataArray count])) {
        return nil;
    }
   // NSLog(@"%d",[[jsonData GetArray] count]);
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.arrayFromViewController = (NSMutableArray*)JsonDataArray;
    

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
    if (index == [JsonDataArray count]) {
        return nil;
    }

  
    return [self viewControllerAtIndex:index];
}

-(void)goToPageIndex:(int)number{
    //Start the page view controller with this first page at index 0;
    startingViewController = [self viewControllerAtIndex:number];
    viewControllers = @[startingViewController];
    
    //set the PageViewController by storyboard ID.
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Table


/*_______________________________________________________________________________________*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [JsonDataArray count];
    
}

//datan som en cell innehåller i min tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //används för identifiering
    static NSString *simpleTableIdentifier = @"myCell";
    
    
    
    //skapa en cell med identifieraren ovan
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //om den inte är nil så allocera en ny cell, skapa med en stil och använd identifieraren ovan
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //ställ in texten i cellen
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.frame = CGRectMake(0,0,40 ,40);
    cell.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@ kr*",[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"],[JsonDataArray[indexPath.row] objectForKey:@"Utpris exkl moms"]];
    
    //[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"];
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
    
    if([jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]] == nil){
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[JsonDataArray[indexPath.row]objectForKey:@"URL"]]];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            
            if(image !=nil){
                
                [jsonData SetFilePath:[jsonData writeToDisc:image index:(int)indexPath.row name:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[(int)indexPath.row] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[(int)indexPath.row] objectForKey:@"Artikelnamn"]]];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(image !=nil){
                    [[cell imageView] setImage:image];
                    [cell setNeedsLayout];
                }
            });
        });
        
        
        
    }else{
        cell.imageView.image = [jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUInteger row = [indexPath row];
    [jsonData SetIndex:indexPath.row];
    
    [self goToPageIndex:(int)indexPath.row];
    
    [self transitionFromViewController:self.ListController
                      toViewController: self.pageViewController
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   // no animation necessary, but docs say this can't be NULL
                               }
                            completion:^(BOOL finished){
                                list = NO;
                                product = YES;
                                [menu HideDownMenu];
                                [self menuBarToFront];
                                [self viewWillDisappear:NO];
                                
                                NSLog(@"you switched");
                            }];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"accessory");
}

- (void) viewWillDisappear:(BOOL)animated {
    [ourTableView deselectRowAtIndexPath:[ourTableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(ShowAlphabet ==YES){
        return indexTitle;
    }
    else if (ShowAlphabet ==NO){
        NSArray *priceTitle = nil;
        return priceTitle;
    }
    else {
        return indexTitle;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    int count = 0;
    int j = 0;
        // Match the section titls with the sections
    NSString* first= [[JsonDataArray[count]objectForKey:@"Artikelnamn"] substringToIndex:1];
    
    for (int i = 0; i< [JsonDataArray count]; i++) {
        first= [[JsonDataArray[count]objectForKey:@"Artikelnamn"] substringToIndex:1];
        if([first isEqualToString:indexTitle[index-j]]){
            NSLog(@"found %@",first);
            break;
        }
        if(count==[JsonDataArray count]-1){
            //nollställ i, count och addera ett till j.
            j+=1;
            i=0;
            count=0;
        }
        count++;
    }

    
    NSLog(@"count %d",count);
    
    [ourTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return count;
}

#pragma mark - Sorting function

-(NSArray*)ourSortingFunction:(NSString*)sort{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:sort ascending:YES selector:@selector(localizedStandardCompare:)];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSArray *sortedArray;
    sortedArray = [JsonDataArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}



@end
