//
//  ViewController.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-03-28.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    // Declare variables here to be global through this class.
    // Background image.
    UIImageView *backgroundView ;
    // Button to sort list view.
    UIButton *priceSortButton;
    UIButton *alphabeticSortButton;
    // Instance to our menu.
    DDMenu *menu;
    // BOOLs to keep track of what view your on.
    BOOL aboutViewIsShowing;
    BOOL kistanViewIsShowing;
    BOOL categoryViewIsShowing;
    BOOL listViewIsShowing;
    BOOL productViewIsShowing;
    // Keep track of scrolling.
    BOOL didbegin;
    BOOL SwipeAway;
    // Used to help sorting.
    BOOL scrollIndicatorIsShowing;
    BOOL ascendingPrice;
    BOOL thereIsResults;
    
    BOOL MenuIsShowing;
    BOOL ShowNoResultsToDisplay;
    BOOL allowToPress;
    
    PageContentViewController *startingViewController;
    NSArray *viewControllers;
    NSArray *indexTitle;

    UIImage *MENU;
    UIImage *magnifierCross;
    UIImage *magnifier;
    UIImage *heart;
    UIImage *heartFilled;
    
    UITableView *ourTableView;

    NSArray *searchResults;
    // For Category.
    UIScrollView *ourScrollView;
    NSMutableDictionary *Categories;
    NSInteger catY;
    NSString *type;
    NSString *info;
    int taggen;
    NSMutableArray *typeArray;
    NSArray *holdingTempResult;
}

@end
@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.multipleTouchEnabled=NO;
    self.view.exclusiveTouch = YES;
    //this array is used for searching and caching images.
    _ForSearchArray = [jsonData GetArray];
    _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];
    //this array is used to display the current filtered products.
    _JsonDataArray = [jsonData GetArray];
    _JsonDataArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_JsonDataArray];


    //cache the keyboard to remove the keyboard first time lag.
    [UIResponder cacheKeyboard];
    //create threads to cache the images from the web.
    [self createThreadsForImageCache];
    //create all the asset images for icons.
    [self createImageAssets];
    //Create all the 5 controllers and background color/image.
    [self createControllersAndBackground];
    //set the top bar menu buttons. Have to be done after controllers are created.
    [self setMenuAndButtons];
    // Go to the first index in gallery view.
    [self goToPageIndex:0];
    //Create searchbar and stuff.
    [self createTableAndSearchBar];
    //Set scroll properties for scroll
    [self createCategoryScrollView];
    //Checks if new content is available
    [self createBackgroundThread];
}

#pragma mark - on Startup functions

-(void)createControllersAndBackground{
    // Set backgroundcolor and image.
    self.view.backgroundColor = [UIColor whiteColor];
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundView];
    
    // Create omOssController.
    self.omOssController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmossViewController"];
    self.omOssController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omOssController willMoveToParentViewController:self];
    [self addChildViewController:self.omOssController];
    
    // Create omKistanController.
    self.omKistanController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmKistanViewController"];
    self.omKistanController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omKistanController willMoveToParentViewController:self];
    [self addChildViewController:self.omKistanController];
    
    // Create categoryController.
    self.categoryController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    self.categoryController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.categoryController willMoveToParentViewController:self];
    [self addChildViewController:self.categoryController];
    
    // Create listcontroller.
    indexTitle = [NSArray arrayWithArray: [@"A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|Å|Ä|Ö" componentsSeparatedByString:@"|"]];
    
    self.ListController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    self.ListController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.ListController willMoveToParentViewController:self];
    [self addChildViewController:self.ListController];
    
    // Create PageViewController.
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    // Change the size of page view controller if needed.
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Set inital values.
    scrollIndicatorIsShowing = YES;
    productViewIsShowing = YES;
}

-(void)createImageAssets{
    magnifier = [UIImage imageNamed:@"magnifier"];
    magnifierCross = [UIImage imageNamed:@"magnifierCross"];
    heart = [UIImage imageNamed:@"smallnotfilled"];
    heartFilled = [UIImage imageNamed:@"smallHeartFilled"];
}

-(void)createTableAndSearchBar{
    // Array for temp results used in gallery view.
    holdingTempResult = [[NSArray alloc] init];
    
    // Create a table.
    ourTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95) ];
    ourTableView.backgroundColor = [UIColor clearColor];
    ourTableView.showsVerticalScrollIndicator = YES;
    ourTableView.delegate = self;
    ourTableView.dataSource = self;
    ourTableView.separatorColor=[UIColor clearColor];
    ourTableView.showsVerticalScrollIndicator = UIScrollViewIndicatorStyleWhite;
    ourTableView.rowHeight = 102;
    [[UITableView appearance] setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSectionIndexColor:[UIColor whiteColor]];
    [self.ListController.view addSubview:ourTableView];
    
    // Set the scope bar.
    _OursearchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0,-100, self.view.frame.size.width, 78)];
    _OursearchBar.showsCancelButton = YES;
    _OursearchBar.delegate = self;
    _OursearchBar.backgroundImage= [UIImage alloc];
    _OursearchBar.scopeBarBackgroundImage = nil;
    _OursearchBar.showsScopeBar = YES;
    _OursearchBar.scopeButtonTitles =[NSArray arrayWithObjects:@"Namn",@"Öltyper", nil];
    _OursearchBar.scopeBarBackgroundImage = [[UIImage alloc] init];
    _OursearchBar.tintColor = [UIColor whiteColor];
    _OursearchBar.barTintColor = [UIColor clearColor];
    _OursearchBar.searchBarStyle = UISearchBarStyleMinimal;

    UIView *view=_OursearchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setTitle:@"Avbryt" forState:UIControlStateNormal];
            [cancelButton setTintColor:[UIColor whiteColor]];
        }
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *searchBarTextField = (UITextField*)subView;
            
            searchBarTextField.textColor = [UIColor whiteColor];
        }
        
    }
    [self.view addSubview: _OursearchBar];
}

-(void)createCategoryScrollView{
    // Used for swiping gesture when you have search results.
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
    
    // Create a scroll for holding categories.
    ourScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70)];
    ourScrollView.backgroundColor = [UIColor clearColor];
    ourScrollView.showsHorizontalScrollIndicator = NO;
    ourScrollView.showsVerticalScrollIndicator = YES;
    [ourScrollView setShowsVerticalScrollIndicator:NO];
    [ourScrollView setShowsHorizontalScrollIndicator:NO];
    [self.categoryController.view  addSubview:ourScrollView];
    [ourScrollView setScrollEnabled:YES];
    [self startCategory];
}

-(void)createBackgroundThread{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (true) {
            if(returningFromBackgroundWithConnection == YES){
                returningFromBackgroundWithConnection = NO;
                dispatch_async(dispatch_get_main_queue(), ^{

                _ForSearchArray = [jsonData GetArray];
                _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];

                     [self createThreadsForImageCache];
                });
            }
            [NSThread sleepForTimeInterval:10];
        }
    });
}

#pragma mark - functions

-(void)noSearchResultsAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Din sökning gav inga träffar"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
}

// Refresh gallery view data source.
-(void)dataSource{
    startingViewController = [self viewControllerAtIndex:0];
    viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        _pageViewController.dataSource = nil;
        _pageViewController.dataSource = self;
    }];
}

#pragma mark - searchBar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    scrollIndicatorIsShowing = NO;

    // Calling filter method.
    [self filterContentForSearchText:searchText
                               scope:[[_OursearchBar scopeButtonTitles] objectAtIndex:[_OursearchBar selectedScopeButtonIndex]]];
    
    if([searchResults count] > 0){
        ShowNoResultsToDisplay = NO;
        _JsonDataArray = searchResults;
        holdingTempResult = searchResults;
        [ourTableView reloadData];
    }
    else if ([searchResults count] ==0 && productViewIsShowing == YES){
        _JsonDataArray = holdingTempResult;
        ShowNoResultsToDisplay = NO;
        
        
    }
    else if ([searchResults count] ==0 && listViewIsShowing == YES){
    _JsonDataArray = nil;

    ShowNoResultsToDisplay = YES;
    [ourTableView reloadData];
        
    }
    if([searchText isEqualToString:@""]){
        ShowNoResultsToDisplay = NO;
        _JsonDataArray = _ForSearchArray;
        [ourTableView reloadData];
    }
    
    if(productViewIsShowing == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
        [self dataSource];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self animateButton:_dropButton Hidden:NO Alpa:1];
    if(listViewIsShowing == YES){
        [self animateButton:alphabeticSortButton Hidden:NO Alpa:1];
        [self animateButton:priceSortButton Hidden:NO Alpa:1];
    }
    //denna kod kollar vad som ska hända när man har tryckt på "sök" knappen.
    //om du har resultat gå in i denna if-sats
    if([_JsonDataArray count]<=[_ForSearchArray count] && [_JsonDataArray count]>0 ){
        
        //animera bort sökfältet och fixa till med datasourcen.
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
        
        if(listViewIsShowing == YES){
            [self animateButton:_cancelSearch Hidden:NO Alpa:1];
        }
        
        //fixa BILDEN
        //om du dessutom är på "produkt" vyn och får sökträffar gör denna kod.
        if(productViewIsShowing == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
            [self dataSource];
            [self animateButton:_cancelSearch Hidden:NO Alpa:1];
        }
        
        //om du inte får några träffar på produkt vyn gör detta kod.
        else if(productViewIsShowing == YES && [_JsonDataArray count] == [_ForSearchArray count]){
            [self noSearchResultsAlert];
            searchBar.text = nil;
            [self dataSource];
            [self animateButton:_searchButton Hidden:NO Alpa:1];
        }
        
    }
    
    //gör denna else om du inte har några träffar i listvyn.
    else{
        [searchBar resignFirstResponder];
        scrollIndicatorIsShowing = YES;
        [self animateButton:_searchButton Hidden:NO Alpa:1];
        [self noSearchResultsAlert];
        
        //special animation with options.
        [UIView animateWithDuration:0.5
        animations:^{
            _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
            _OursearchBar.alpha = 0;
        }
        completion:^(BOOL finished) {
            _JsonDataArray = _ForSearchArray;
            ShowNoResultsToDisplay = NO;
            [ourTableView reloadData];
            searchBar.text = nil;
        }];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //fix buttons
    [self animateButton:_dropButton Hidden:NO Alpa:1];
    [self animateButton:_searchButton Hidden:NO Alpa:1];
    if(listViewIsShowing == YES){
    [self animateButton:alphabeticSortButton Hidden:NO Alpa:1];
    [self animateButton:priceSortButton Hidden:NO Alpa:1];
    }
    
    if([_JsonDataArray count]<=[_ForSearchArray count]){
        
        searchBar.text = nil;
        scrollIndicatorIsShowing = YES;
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
        ShowNoResultsToDisplay = NO;
        _JsonDataArray = _ForSearchArray;
        [ourTableView reloadData];
        
            if(productViewIsShowing == YES && [_JsonDataArray count] != 0){
                [self dataSource];
            }
    }
    else {
        
        searchBar.text = nil;
        scrollIndicatorIsShowing = YES;
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
    }
}

-(void)searchBarAnimationUp{
    [UIView animateWithDuration:0.35 animations:^{
        _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
        _OursearchBar.alpha = 0;
    }
     
                     completion:^(BOOL finished) {
                         
    }];
}

-(void)SearchIconPressed{

    [self animateButton:_dropButton Hidden:YES Alpa:0];
    [self animateButton:_searchButton Hidden:YES Alpa:0];
    [self animateButton:alphabeticSortButton Hidden:YES Alpa:0];
    [self animateButton:priceSortButton Hidden:YES Alpa:0];
    
        [_OursearchBar becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _OursearchBar.alpha = 1;
            _OursearchBar.frame = CGRectMake(0, 22,  self.view.frame.size.width, 78);
            
        } completion:^(BOOL finished) {
        }];
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{

    if(selectedScope == 0){
        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Artikelnamn contains[c] %@", _OursearchBar.text]];
    }else if(selectedScope == 1){
        
        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Kategori contains[c] %@", _OursearchBar.text]];
        
    }
    if([searchResults count]>0){
        ShowNoResultsToDisplay = NO;
        _JsonDataArray = searchResults;
        holdingTempResult = searchResults;
        [ourTableView reloadData];
    }
    else if ([searchResults count] ==0 && productViewIsShowing == YES){
        _JsonDataArray = holdingTempResult;
        ShowNoResultsToDisplay = NO;
        
        
    }
    else if ([searchResults count] ==0 && listViewIsShowing == YES){
        _JsonDataArray = nil;
        
        ShowNoResultsToDisplay = YES;
        [ourTableView reloadData];
        
    }
    if([_OursearchBar.text isEqualToString:@""]){
        ShowNoResultsToDisplay = NO;
        _JsonDataArray = _ForSearchArray;
        [ourTableView reloadData];
    }
    
    if(productViewIsShowing == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
        [self dataSource];
    }

}

-(void)SearchRemoveResultsButtonClicked{
    [self animateButton:_cancelSearch Hidden:YES Alpa:0];
    [self animateButton:_searchButton Hidden:NO Alpa:1];
    _JsonDataArray = _ForSearchArray;
    _OursearchBar.text = nil;
    //table view
    scrollIndicatorIsShowing = YES;
    ShowNoResultsToDisplay = NO;

    [ourTableView reloadData];
    [self dataSource];


}

#pragma mark - background caching

-(void)createThreadsForImageCache{
    int threadNumber = 0;
    int MaxThreads = 1;
    // NSDate *startDate = [NSDate date];
    
    while(threadNumber < MaxThreads+1){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Load the shared assets in the background.
        for (int i = threadNumber; i < (int)[_ForSearchArray count] ; i+=2) {
            UIImage *image;
            
            if([jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] == nil){
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_ForSearchArray[i]objectForKey:@"URL"]]];
                image = [[UIImage alloc] initWithData:imageData];
                
                if(image != nil){
                    [jsonData SetFilePath:[jsonData writeToDisc:image name:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]];
                }
            }
        }
        // NSLog(@"Loaded all create images in %f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    });
        threadNumber++;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = (int)[_ForSearchArray count]-1; i > 0 ; i--) {
            UIImage *image;
            
            if([jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] == nil){
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_ForSearchArray[i]objectForKey:@"URL"]]];
                image = [[UIImage alloc] initWithData:imageData];
                
                if(image != nil){
                    [jsonData SetFilePath:[jsonData writeToDisc:image name:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]];
                }
            }
        }
      // NSLog(@"Loaded all create images in %f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    });
}

#pragma mark - Other

- (void)didReceiveMemoryWarning{
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Switching between views.

- (void)switchTo:(UIViewController *)from to:(UIViewController *)controller{
    if ([controller isEqual:self.pageViewController]){
        productViewIsShowing = YES;
    }
    else if ([controller isEqual:self.ListController]){
        listViewIsShowing = YES;
    }
    else if ([controller isEqual:self.omOssController]){
        aboutViewIsShowing = YES;
    }
    else if ([controller isEqual:self.omKistanController]){
        kistanViewIsShowing = YES;
    }
    else if( [controller isEqual:self.categoryController]){
        categoryViewIsShowing = YES;
    }
    
    if(from != controller){
    [self transitionFromViewController:from
                      toViewController: controller
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               // No animation necessary, but docs say this can't be NULL.
                               }
                            completion:^(BOOL finished){
                                
                                [menu HideDownMenu:self.view.frame.size.width];
                                [self slideAllViews];
                                [self.view bringSubviewToFront:_OursearchBar];
                                [self menuBarToFront];
                                [_dropButton setImage:MENU forState:UIControlStateNormal];
            }];
        
    }
    else{
        [menu HideDownMenu:self.view.frame.size.width];
        MenuIsShowing = NO;
        [self slideAllViews];
        [self menuBarToFront];
        [_dropButton setImage:MENU forState:UIControlStateNormal];
    
    }
    [self checkWhatButtonsToShowInView];
}

-(void)checkWhatButtonsToShowInView{
    if(productViewIsShowing == YES || listViewIsShowing == YES){
        _searchButton.hidden = NO;
    }
    else{
        _searchButton.hidden = YES;
    }
    
    if(listViewIsShowing == YES){
        alphabeticSortButton.hidden = NO;
        priceSortButton.hidden = NO;
    }
    else{
        alphabeticSortButton.hidden = YES;
        priceSortButton.hidden = YES;
        [_dropButton setImage:MENU forState:UIControlStateNormal];
    }
}

-(void)pushedMenuButton:(UIButton *)sender{
    if(sender.tag == 0){
        [self switchTo:[self GetCurrentViewController] to:self.pageViewController];
    }
    else if(sender.tag == 1){
        [self switchTo:[self GetCurrentViewController] to:self.ListController];
    }
    else if(sender.tag == 2){
        [self switchTo:[self GetCurrentViewController] to:self.categoryController];
        
    }
    else if (sender.tag == 3){
        [self switchTo:[self GetCurrentViewController] to:self.omKistanController];
        
    }
    else if(sender.tag == 4){
        [self switchTo:[self GetCurrentViewController] to:self.omOssController];
    }
    
}

-(id)GetCurrentViewController{
    if (listViewIsShowing == YES){
        listViewIsShowing = NO;
        return self.ListController;
    }
    else if (productViewIsShowing == YES){
        productViewIsShowing = NO;
        return self.pageViewController;
    }
    else if (aboutViewIsShowing == YES){
        aboutViewIsShowing = NO;
        return self.omOssController;
    }
    else if (kistanViewIsShowing == YES){
        kistanViewIsShowing = NO;
        return self.omKistanController;
    }
    else if( categoryViewIsShowing == YES){
        categoryViewIsShowing = NO;
        return self.categoryController;
    }
    else{
        productViewIsShowing = NO;
        return self.pageViewController;
    }
}

#pragma mark - Buttons and menu

-(void)setMenuAndButtons{
    MenuIsShowing = NO;
    MENU = [UIImage imageNamed:@"menu"];
    
    _dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dropButton.frame = CGRectMake(self.view.frame.size.width-55, 20, 55, 55);
    [_dropButton setImage:MENU forState:UIControlStateNormal];
    [_dropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dropButton addTarget:self action:@selector(DropMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dropButton];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(4, 20, 55, 55);
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(SearchIconPressed)
           forControlEvents:UIControlEventTouchUpInside];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_searchButton];
    
    _cancelSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelSearch.frame = CGRectMake(4, 20, 55, 55);
    [_cancelSearch setImage:magnifierCross forState:UIControlStateNormal];
    [_cancelSearch addTarget:self action:@selector(SearchRemoveResultsButtonClicked)
            forControlEvents:UIControlEventTouchUpInside];
    _cancelSearch.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_cancelSearch];
    _cancelSearch.hidden = YES;
    
    UIImage *priceSortIcon = [UIImage imageNamed:@"Pris"];

    priceSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceSortButton.frame = CGRectMake(64, 20, 55, 55);
    [priceSortButton setImage:priceSortIcon forState:UIControlStateNormal];
    [priceSortButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    priceSortButton.titleLabel.font = [UIFont systemFontOfSize:20];
    priceSortButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [priceSortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceSortButton addTarget:self action:@selector(sortPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priceSortButton];
    
    UIImage *AZ = [UIImage imageNamed:@"A-Z"];
    alphabeticSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alphabeticSortButton.frame = CGRectMake(124, 20, 55, 55);
    alphabeticSortButton.titleLabel.font = [UIFont systemFontOfSize:20];
    alphabeticSortButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [alphabeticSortButton setImage:AZ forState:UIControlStateNormal];
    [alphabeticSortButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alphabeticSortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alphabeticSortButton addTarget:self action:@selector(sortAlphabetically) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alphabeticSortButton];
    
    alphabeticSortButton.hidden = YES;
    priceSortButton.hidden = YES;
    
    menu = [[DDMenu alloc ]initWithFrame:CGRectMake( self.view.frame.size.width+220, 0, 220, self.view.frame.size.height)];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_OursearchBar];
    [self.view bringSubviewToFront:_searchButton];
    [self.view bringSubviewToFront:_cancelSearch];
    
    allowToPress = YES;

    for(UIView* v in self.view.subviews){
        if([v isKindOfClass:[UIButton class]]){
            UIButton* btn = (UIButton*)v;
            [btn setExclusiveTouch:YES];
        }
    }
}

-(void)DropMenu{
    if(MenuIsShowing == NO && allowToPress == YES){
        allowToPress = NO;
        SwipeAway = YES;
        
        [_dropButton setImage:magnifierCross forState:UIControlStateNormal];
        [self animateButton:_searchButton Hidden:YES Alpa:0];
        [self animateButton:alphabeticSortButton Hidden:YES Alpa:0];
        [self animateButton:priceSortButton Hidden:YES Alpa:0];
        [self animateButton:_cancelSearch Hidden:YES Alpa:0];
    
        [menu DropDownMenu:self.view.frame.size.width];
        [[menu omOssButton] addTarget:self action:@selector(pushedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [[menu omKistanButton] addTarget:self action:@selector(pushedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [[menu categoryButton] addTarget:self action:@selector(pushedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [[menu productViewButton] addTarget:self action:@selector(pushedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [[menu listViewButton] addTarget:self action:@selector(pushedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.pageViewController.view.frame = CGRectMake(-self.pageViewController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
            self.ListController.view.frame = CGRectMake(-self.ListController.view.frame.size.width, 0,  self.ListController.view.frame.size.width,  self.ListController.view.frame.size.height);

            self.omKistanController.view.frame = CGRectMake(-self.omKistanController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

            self.omOssController.view.frame = CGRectMake(-self.omOssController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

            self.categoryController.view.frame = CGRectMake(-self.categoryController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

        } completion:^(BOOL finished) {
            allowToPress= YES;
        }];
        MenuIsShowing = YES;
    }
    else if (MenuIsShowing == YES && allowToPress == YES){
        allowToPress = NO;
        SwipeAway = NO;
        [_dropButton setImage:MENU forState:UIControlStateNormal];
        [menu HideDownMenu:self.view.frame.size.width];
         MenuIsShowing = NO;
        
            if([_JsonDataArray count]<[_ForSearchArray count]){
                thereIsResults = YES;
            }
            else{
            thereIsResults = NO;
            }
        
            if( (listViewIsShowing == YES  && thereIsResults == NO) || (productViewIsShowing == YES && thereIsResults == NO)){
                [self animateButton:_searchButton Hidden:NO Alpa:1];
            }
            else if((listViewIsShowing == YES  && thereIsResults == YES) ||(productViewIsShowing == YES && thereIsResults == YES)){
                [self animateButton:_cancelSearch Hidden:NO Alpa:1];
            }
            if(listViewIsShowing == YES){
                [self animateButton:alphabeticSortButton Hidden:NO Alpa:1];
                [self animateButton:priceSortButton Hidden:NO Alpa:1];
            }

        [UIView animateWithDuration:0.5 animations:^{
            self.pageViewController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
            self.ListController.view.frame = CGRectMake(0, 0,  self.ListController.view.frame.size.width,  self.ListController.view.frame.size.height);
            self.omKistanController.view.frame = CGRectMake(0, 0,  self.omKistanController.view.frame.size.width,  self.omKistanController.view.frame.size.height);
            self.omOssController.view.frame = CGRectMake(0, 0,  self.omOssController.view.frame.size.width,  self.omOssController.view.frame.size.height);
            self.categoryController.view.frame = CGRectMake(0, 0,  self.categoryController.view.frame.size.width,  self.categoryController.view.frame.size.height);
        } completion:^(BOOL finished) {
            allowToPress = YES;
        }];
    }
}

-(void)menuBarToFront{
    MenuIsShowing = NO;
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_searchButton];
    [self.view bringSubviewToFront:_OursearchBar];
    [self.view bringSubviewToFront:_cancelSearch];
    [self.view bringSubviewToFront:alphabeticSortButton];
    [self.view bringSubviewToFront:priceSortButton];
    
    if([_JsonDataArray count] < [_ForSearchArray count]){
        thereIsResults = YES;
    }
    else{
        thereIsResults = NO;
    }
    
    if( (listViewIsShowing == YES  && thereIsResults == NO) || (productViewIsShowing == YES && thereIsResults == NO)){
        [self animateButton:_searchButton Hidden:NO Alpa:1];
    }
    else if((listViewIsShowing == YES && thereIsResults == YES) || (productViewIsShowing == YES && thereIsResults == YES)){
        [self animateButton:_cancelSearch Hidden:NO Alpa:1];
    }
    if(listViewIsShowing == YES){
        [self animateButton:alphabeticSortButton Hidden:NO Alpa:1];
        [self animateButton:priceSortButton Hidden:NO Alpa:1];
    }
}

-(void)slideAllViews{
    [UIView animateWithDuration:0.5 animations:^{
        self.pageViewController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        self.ListController.view.frame = CGRectMake(0, 0,  self.ListController.view.frame.size.width,  self.ListController.view.frame.size.height);
        
        self.omKistanController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
        self.omOssController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
        self.categoryController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
    }
                     completion:^(BOOL finished) {
                     }];

}

-(void)animateButton:(UIButton*)Button Hidden:(BOOL)yesOrNo Alpa:(int)zeroOrOne{
    if(Button.hidden == YES){
        Button.hidden = yesOrNo;
        [UIView animateWithDuration:0.35 animations:^{
            Button.alpha = zeroOrOne;
        }
                         completion:^(BOOL finished) {
                         }];
        
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            Button.alpha = zeroOrOne;
        }
                         completion:^(BOOL finished) {
                             Button.hidden = yesOrNo;
                         }];
    }
}
/*
- (IBAction)SwipeAwayMenu:(id)sender {
    if(SwipeAway == YES){
        SwipeAway = NO;
        [self DropMenu];
    }
}
*/
#pragma mark - Sorting indexs in tableView

-(void)sortAlphabetically{
    _JsonDataArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_JsonDataArray];
    
    if([_JsonDataArray count] == [_ForSearchArray count]){
      scrollIndicatorIsShowing = YES;
    }
    
    [ourTableView reloadData];
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;
}

-(void)sortPrice{
    if(ascendingPrice == YES){
        ascendingPrice = NO;
        _JsonDataArray = [self ourSortingFunction:@"Utpris exkl moms" ascending:ascendingPrice withArray:_JsonDataArray];
        scrollIndicatorIsShowing = NO;
        [ourTableView reloadData];

        self.pageViewController.dataSource = nil;
        self.pageViewController.dataSource = self;
        
    }
    else if (ascendingPrice == NO){
        ascendingPrice = YES;
        _JsonDataArray = [self ourSortingFunction:@"Utpris exkl moms" ascending:ascendingPrice withArray:_JsonDataArray];
        scrollIndicatorIsShowing = NO;
        [ourTableView reloadData];
        
        self.pageViewController.dataSource = nil;
        self.pageViewController.dataSource = self;
    }
}

#pragma mark PageViewController

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([_JsonDataArray count] == 0) ||( index >= [_JsonDataArray count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.arrayFromViewController = (NSMutableArray*)_JsonDataArray;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)){
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
 
    if (index == NSNotFound){
        return nil;
    }
    index++;
    
    if (index == [_JsonDataArray count]){
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(!completed){
        return;
    }
}

-(void)goToPageIndex:(int)number{
    //Start the page view controller with this first page at index 0;
    startingViewController = [self viewControllerAtIndex:number];
    viewControllers = @[startingViewController];
    //set the PageViewController by storyboard ID.
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(ShowNoResultsToDisplay == NO){
        return [_JsonDataArray count];
    }
    else if (ShowNoResultsToDisplay == YES){
        return 1;
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Used for identifying.
    static NSString *simpleTableIdentifier = nil;
    // Create a cell with the identifyer above.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    // No result in a search.
    if (ShowNoResultsToDisplay) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = @"Inga träffar";
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.shadowColor =[UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(1, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    else{
    // If not nil, create a new cell.
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        }
        
    // Create no result label.
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.shadowColor =[UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(1, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.frame = CGRectMake(0,0,40 ,40);
    cell.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",[_JsonDataArray[indexPath.row]
                                    objectForKey:@"Artikelnamn"],[_JsonDataArray[indexPath.row] objectForKey:@"Kategori"]];

    UIImage *imgFromMem =[jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]];
    
        if (imgFromMem != nil){
            cell.imageView.image = imgFromMem;
            }
        
        UILabel *priceLabel;
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(235,50,60,20)];
        [priceLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        priceLabel.text =[NSString stringWithFormat:@"%@ kr*",[_JsonDataArray[indexPath.row] objectForKey:@"Utpris exkl moms"]];
        priceLabel.backgroundColor=[UIColor clearColor];
        priceLabel.numberOfLines=1;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.shadowColor =[UIColor blackColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.shadowOffset = CGSizeMake(1, 1);
        [cell.contentView addSubview:priceLabel];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (ShowNoResultsToDisplay) {
        // Do nothing if hit
    }
    else{
        [jsonData SetIndex:indexPath.row];
        [self goToPageIndex:(int)indexPath.row];
        alphabeticSortButton.alpha = 0 ;
        alphabeticSortButton.hidden = YES;
        priceSortButton.alpha = 0 ;
        priceSortButton.hidden = YES;
        
        [self transitionFromViewController:self.ListController
                          toViewController: self.pageViewController
                                  duration:0.4
                                   options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   // No animation necessary, but docs say this can't be NULL.
                               }
                            completion:^(BOOL finished){
                                    listViewIsShowing = NO;
                                    productViewIsShowing = YES;
                                    [menu HideDownMenu:self.view.frame.size.width];
                                    [self menuBarToFront];
                                    [self viewWillDisappear:NO];
                                    [self animateButton:_dropButton Hidden:NO Alpa:1];

                                    [_OursearchBar resignFirstResponder];
                                    [UIView animateWithDuration:0.5 animations:^{
                                    _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
                                    _OursearchBar.alpha = 0;
                                    }
                                                     completion:^(BOOL finished) {
                                                     }];
                            }];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [ourTableView deselectRowAtIndexPath:[ourTableView indexPathForSelectedRow] animated:animated];
    [super viewWillDisappear:animated];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(scrollIndicatorIsShowing == YES){
        return indexTitle;
    }
    else if (scrollIndicatorIsShowing == NO){
        NSArray *priceTitle = nil;
        return priceTitle;
    }
    else{
        return indexTitle;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    int count = 0;
    int j = 0;
    // Match the section titles with the sections
    NSString* first= [[_JsonDataArray[count]objectForKey:@"Artikelnamn"] substringToIndex:1];
    
    for(int i = 0; i< [_JsonDataArray count]; i++) {
        first= [[_JsonDataArray[count]objectForKey:@"Artikelnamn"] substringToIndex:1];
        if([first isEqualToString:indexTitle[index-j]]){
            break;
        }
        if(count==[_JsonDataArray count]-1){
            //nollställ i, count och addera ett till j.
            j+=1;
            i=0;
            count=0;
        }
        count++;
    }
    [ourTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return count;
}

#pragma mark - Sorting function

-(NSArray*)ourSortingFunction:(NSString*)sort ascending:(BOOL)order withArray:(NSArray*)array{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:sort ascending:order selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    if([scope isEqualToString:@"Namn"]){
        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Artikelnamn contains[c] %@", searchText]];
    }
    else if([scope isEqualToString:@"Öltyper"]){
        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Kategori contains[c] %@", searchText]];
    }
}

#pragma mark - extra

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(productViewIsShowing == YES && didbegin == NO){
        didbegin =YES;
        [_OursearchBar resignFirstResponder];
    }
    else if(listViewIsShowing == YES && didbegin == NO){
        didbegin =YES;
        [_OursearchBar resignFirstResponder];
    }
    _contentOffsetInPage = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    didbegin = NO;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake && productViewIsShowing == YES){
        [self goToPageIndex:(int)[self getRandomNumberBetween:0 maxNumber:[_JsonDataArray count]-1]];
    }
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max{
    return min + arc4random() % (max - min + 1);
}

#pragma mark - Category

-(void)startCategory{
    catY = 0;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPatch = [path stringByAppendingPathComponent:@"CategoryList.plist"];
    Categories = [NSDictionary dictionaryWithContentsOfFile:finalPatch];
    typeArray = [[NSMutableArray alloc] init];
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    typeArray = [Categories objectForKey:@"Type"];
    infoArray = [Categories objectForKey:@"Info"];
    
    for(int i = 0; i < [typeArray count]; i++) {
        taggen = i;
        type = [typeArray objectAtIndex:i];
        info = [infoArray objectAtIndex:i];
        [self createCategoryHead];
        [self createCategoryBody];
    }
}

-(void)createCategoryHead{
    UIButton *categoryInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [categoryInfo setFrame:CGRectMake(20, catY, self.view.frame.size.width-40, 50)];
    [categoryInfo setTitle:type forState:UIControlStateNormal];
    [categoryInfo setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [categoryInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [categoryInfo addTarget:self action:@selector(presentBeerTypeInList:) forControlEvents:UIControlEventTouchUpInside];
    categoryInfo.tag = taggen;
    categoryInfo.titleLabel.shadowOffset = CGSizeMake(1, 1);
    categoryInfo.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
    categoryInfo.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [ourScrollView addSubview:categoryInfo];
    catY = catY + 50;
}

-(void)createCategoryBody{
    UILabel *CategoryInfo = [[UILabel alloc]initWithFrame:CGRectMake(20, catY, self.view.frame.size.width-40, 200)];
    CategoryInfo.text = info;
    CategoryInfo.numberOfLines = 30;
    CategoryInfo.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    CategoryInfo.shadowColor =[UIColor blackColor];
    CategoryInfo.shadowOffset = CGSizeMake(1, 1);
    CategoryInfo.backgroundColor = [UIColor clearColor];
    CategoryInfo.textColor = [UIColor whiteColor];
    CategoryInfo.textAlignment = NSTextAlignmentLeft;
    [CategoryInfo sizeToFit];
    [ourScrollView addSubview:CategoryInfo];
    catY = catY + CategoryInfo.frame.size.height+20;
    ourScrollView.contentSize = CGSizeMake(self.view.frame.size.width, catY + 50);
}

-(void)presentBeerTypeInList:(UIButton *)sender{
    _JsonDataArray = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Kategori ==[c] %@",
                                                                   [typeArray objectAtIndex:(int)sender.tag]]];
    //Special case when we need to set some BOOLs to NO!
    categoryViewIsShowing = NO;
    scrollIndicatorIsShowing =NO;
    [ourTableView reloadData];
    
    [self switchTo:self.categoryController to:self.ListController];
    [self dataSource];
}

BOOL returningFromBackgroundWithConnection;
+(BOOL)restartCache:(bool)forCache{
    returningFromBackgroundWithConnection = forCache;
    return returningFromBackgroundWithConnection;
}

#pragma mark - Touch

float difference;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint contentTouchPoint = [[touches anyObject] locationInView:menu];
    difference = contentTouchPoint.x;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint pointInView = [[touches anyObject] locationInView:self.view];
    float xTarget = pointInView.x - difference;
    
    if(xTarget > menu.frame.size.width)
        xTarget = menu.frame.size.width;
    else if( xTarget < 0)
        xTarget = 0;
    [UIView animateWithDuration:.25
                     animations:^{
                         [menu HideDownMenuWithStyle:self.view.frame.size.width xCord:xTarget];

                       //  [ setFrame:CGRectMake(xTarget, content.frame.origin.y, content.frame.size.width, content.frame.size.height)];
                     }
     ];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint endPoint = [[touches anyObject] locationInView:self.view];
    float xTarget = endPoint.x - difference;
    
    if(xTarget > (menu.frame.size.width/4)){
        xTarget = 0;
        [UIView animateWithDuration:.25
                     animations:^{
                         [self DropMenu];
                     }
         ];}
    else{
        [menu  DropDownMenu:self.view.frame.size.width];
    }
    

}

@end
