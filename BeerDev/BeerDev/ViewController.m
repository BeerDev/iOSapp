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
    BOOL noResultsToDisplay;

    UIButton* priceSort;
    UIButton* alphabeticSort;
   
    DDMenu*menu;
    BOOL about;
    BOOL kistan;
    BOOL category;
    BOOL list;
    BOOL product;
    
    BOOL ShowAlphabet;
    BOOL ascendingPrice;
    
    PageContentViewController *startingViewController;
    NSArray *viewControllers;
    NSArray *indexTitle;

    UIImage *magnifierCross;
    UIImage *magnifier;
    //table
    UITableView *ourTableView;

    NSArray * searchResults;
    
    //For Category
    UIScrollView * scrollView;
   NSMutableDictionary *Categories;
    NSInteger catY;
    NSString *type;
    NSString *info;
    
}
@end
@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    //cache the keyboard
    [UIResponder cacheKeyboard];
    magnifier = [UIImage imageNamed:@"magnifier"];
    magnifierCross = [UIImage imageNamed:@"magnifierCross"];
    //this array is used for searching and caching images
    _ForSearchArray = [jsonData GetArray];
    _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];

    //this array is used to display the current filtered products
    _JsonDataArray = [jsonData GetArray];
    _JsonDataArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_JsonDataArray];

    [self setButton];
    [self cacheEverything];
    //set backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    
    ShowAlphabet = YES;
    
    //create omOssController
    self.omOssController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmossViewController"];
    self.omOssController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omOssController willMoveToParentViewController:self];
    [self addChildViewController:self.omOssController];
    
    //create omKistanController
    self.omKistanController = [self.storyboard instantiateViewControllerWithIdentifier:@"OmKistanViewController"];
    self.omKistanController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.omKistanController willMoveToParentViewController:self];
    [self addChildViewController:self.omKistanController];
    
    //create categoryController
    self.categoryController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    self.categoryController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.categoryController willMoveToParentViewController:self];
    [self addChildViewController:self.categoryController];
    
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

    menu = [[DDMenu alloc ]initWithFrame:CGRectMake(0, -220, self.view.frame.size.width, 220)];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_OursearchBar];
    [self.view bringSubviewToFront:_searchButton];
    

    //Create a table
    ourTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95) ];
    [self.ListController.view addSubview:ourTableView];
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
    
    [self createListButtons];
    
    //Create searchbar and stuff.
    
    _OursearchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0,-100, self.view.frame.size.width, 78)];
    _OursearchBar.showsCancelButton = YES;
    _OursearchBar.delegate = self;
    _OursearchBar.backgroundImage= [UIImage alloc];
    //set the scope bar
    _OursearchBar.scopeBarBackgroundImage = nil;
    _OursearchBar.showsScopeBar = YES;
    _OursearchBar.scopeButtonTitles =[NSArray arrayWithObjects:@"Namn",@"Kategori", nil];
    
    _OursearchBar.scopeBarBackgroundImage = [[UIImage alloc] init];
    _OursearchBar.tintColor = [UIColor whiteColor];
    _OursearchBar.barTintColor = [UIColor clearColor];

     UIView* view=_OursearchBar.subviews[0];
     for (UIView *subView in view.subviews) {
         if ([subView isKindOfClass:[UIButton class]]) {
             UIButton *cancelButton = (UIButton*)subView;
             
             [cancelButton setTitle:@"Avbryt" forState:UIControlStateNormal];
             [cancelButton setTintColor:[UIColor whiteColor]];
         }
     }

    [self.view addSubview: _OursearchBar];
    //Category
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    //[scrollView setDelegate:self];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.categoryController.view  addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 3800);
    [scrollView setScrollEnabled:YES];
    [self startCategory];
    
    //en lyssnartråd! :D
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        int temp = 0;
        while (temp <1) {
            temp++;
            [NSThread sleepForTimeInterval:5];
            if([_ForSearchArray count] < [[jsonData GetArray] count] || [_ForSearchArray count] > [[jsonData GetArray] count]){
            _ForSearchArray = [jsonData GetArray];
            _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];
            }
          //  NSLog(@"sovande bakgrundstråd! temp %d",temp);
            temp--;
        }
    });
    
    
}


#pragma mark - searchBar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    ShowAlphabet = NO;

    [self filterContentForSearchText:searchText
                               scope:[[_OursearchBar scopeButtonTitles]
                                      objectAtIndex:[_OursearchBar
                                                     selectedScopeButtonIndex]]];
    
    if([searchResults count]>0){
    noResultsToDisplay = NO;
    _JsonDataArray = searchResults;
    [ourTableView reloadData];
    }
    else if ([searchResults count] <=0 && product == YES){
        _JsonDataArray = _ForSearchArray;
        noResultsToDisplay = NO;
        
    }
    else if ([searchResults count] <=0 && list == YES){
    _JsonDataArray = nil;
    noResultsToDisplay = YES;
    [ourTableView reloadData];
        
    }
  
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _dropButton.hidden = NO;
    
    //denna kod kollar vad som ska hända när man har tryckt på "sök" knappen.
    //om du har resultat gå in i denna if-sats
    if([_JsonDataArray count]<=[_ForSearchArray count] && [_JsonDataArray count]>0 ){
        //animera bort sökfältet och fixa till med datasourcen.
        [searchBar resignFirstResponder];
        
        //animerings kod
        [UIView animateWithDuration:0.5 animations:^{
                _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
                _OursearchBar.alpha = 0;
        }
         
                         completion:^(BOOL finished) {
                             self.pageViewController.dataSource = nil;
                             self.pageViewController.dataSource = self;
   
                         }];
        //fixa BILDEN
        [_searchButton setImage:magnifierCross forState:UIControlStateNormal];
        //om du dessutom är på "produkt" vyn och får sökträffar gör denna kod.
            if(product == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
                startingViewController = [self viewControllerAtIndex:0];
                viewControllers = @[startingViewController];
                
                [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
                self.pageViewController.dataSource = self;
                }
        
        //om du inte får några träffar på produkt vyn gör detta kod.
            else if(product == YES && [_JsonDataArray count] == [_ForSearchArray count]){
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Din sökning gav inga träffar"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                [alert show];
            
                startingViewController = [self viewControllerAtIndex:0];
                viewControllers = @[startingViewController];
            
                [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
                self.pageViewController.dataSource = self;
        }
        
    }
    
    //gör denna else om du inte har några träffar i listvyn.
        else{
        [searchBar resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Din sökning gav inga träffar"
                                                        delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        [UIView animateWithDuration:0.5 animations:^{
            _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
            _OursearchBar.alpha = 0;
        } completion:^(BOOL finished) {
            _JsonDataArray = _ForSearchArray;
            noResultsToDisplay = NO;
            [ourTableView reloadData];
            searchBar.text = nil;
        }];
    }
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _dropButton.hidden = NO;
    if([_JsonDataArray count]<=[_ForSearchArray count]){
    searchBar.text = nil;
    ShowAlphabet = YES;
    [searchBar resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
        } completion:^(BOOL finished) {
        self.pageViewController.dataSource = nil;
        self.pageViewController.dataSource = self;
        }];
        
        [_searchButton setImage:magnifier forState:UIControlStateNormal];
    
    _JsonDataArray = _ForSearchArray;
    [ourTableView reloadData];
        
    if(product == YES && [_JsonDataArray count] != 0){
        
        startingViewController = [self viewControllerAtIndex:0];
        viewControllers = @[startingViewController];
        
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

        self.pageViewController.dataSource = self;
    }
    }else {
        searchBar.text = nil;
        ShowAlphabet = YES;
        [searchBar resignFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
        } completion:^(BOOL finished) {

        }];
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //titta på detta senare!!
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
}




-(void)SearchIconPressed{
        _dropButton.hidden = YES;
        [_OursearchBar becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _OursearchBar.alpha = 1;
            _OursearchBar.frame = CGRectMake(0, 22,  self.view.frame.size.width, 78);
            
        } completion:^(BOOL finished) {
        }];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
   
    
    if([scope isEqualToString:@"Namn"]){
   
        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Artikelnamn contains[c] %@", searchText]];
    }else if([scope isEqualToString:@"Kategori"]){

        searchResults = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Kategori contains[c] %@", searchText]];

    }
}


#pragma mark - background caching
-(void)cacheEverything{
    int threadNumber = 1;
    int MaxThreads = 2;
    NSDate *startDate = [NSDate date];
    while(threadNumber <MaxThreads+1){
   
    
    //jämna nummer
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load the shared assets in the background.
        //[self loadSceneAssets];
        NSLog(@"laddning sker på tråd nr %d",threadNumber);
        for (int i = threadNumber; i < (int)[_ForSearchArray count] ; i+=2) {
        //    NSLog(@"getting %d",i);
            UIImage* image;
            if([jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]]] == nil){
                
                NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_ForSearchArray[i]objectForKey:@"URL"]]];
              //  NSLog(@"%@",[JsonDataArray[i]objectForKey:@"URL"]);
                image = [[UIImage alloc] initWithData:imageData];
                
                if(image !=nil){
                   // NSLog(@ "cached image nr %d",i);
                    [jsonData SetFilePath:[jsonData writeToDisc:image index:i name:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]];
                }
            }
        }
        NSLog(@"Loaded all create images in %f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    });
        threadNumber++;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = (int)[_ForSearchArray count]-1; i > 0 ; i--) {
          //  NSLog(@"getting %d",i);
            UIImage* image;
            if([jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]]] == nil){
                
                NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_ForSearchArray[i]objectForKey:@"URL"]]];
                image = [[UIImage alloc] initWithData:imageData];
                
                if(image !=nil){
                   // NSLog(@"cached image nr %d",i);
                    [jsonData SetFilePath:[jsonData writeToDisc:image index:i name:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[_ForSearchArray[i] objectForKey:@"Artikelnamn"]]];
                }
            }
        }
      NSLog(@"Loaded all create images in %f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    });
}

#pragma mark - Other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
                                [self.view bringSubviewToFront:_OursearchBar];
            }];
    if(product == YES || list == YES){
          _searchButton.hidden = NO;
    }else{
        _searchButton.hidden = YES;
    }
    
}

-(void)GoToProductInfo{
    if (about == YES) {
        about = NO;
        product = YES;
        _searchButton.hidden = NO;
        [self switchTo:self.omOssController to:self.pageViewController];
        [self menuBarToFront];
    }
    else if (list == YES){
        list = NO;
        product = YES;
        _searchButton.hidden = NO;
        [self switchTo:self.ListController to:self.pageViewController];
        [self menuBarToFront];
    }
    else if (kistan == YES){
        kistan = NO;
        product = YES;
        _searchButton.hidden = YES;
        [self switchTo:self.omKistanController to:self.pageViewController];
        [self menuBarToFront];
    }
    else if (category == YES){
        category = NO;
        product = YES;
        _searchButton.hidden = YES;
        [self switchTo:self.categoryController to:self.pageViewController];
        [self menuBarToFront];
    }
    
    else{
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
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
    else if (kistan == YES){
        kistan = NO;
        list = YES;
        [self switchTo:self.omKistanController to:self.ListController];
        [self menuBarToFront];
    }
    else if (category == YES){
        category = NO;
        list = YES;
        [self switchTo:self.categoryController to:self.ListController];
        [self menuBarToFront];
    }
    else
    {
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
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
        about = YES;
        [self switchTo:self.pageViewController to:self.omOssController];
        [self menuBarToFront];
    }
    else if (kistan == YES){
        kistan = NO;
        about = YES;
        [self switchTo:self.omKistanController to:self.omOssController];
        [self menuBarToFront];
    }
    else if (category == YES){
        category = NO;
        about = YES;
        [self switchTo:self.categoryController to:self.omOssController];
        [self menuBarToFront];
    }
    else
    {
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
        button = NO;
    }
}
-(void)GoToOmKistan{
    if (list == YES) {
        list = NO;
        kistan = YES;
        [self switchTo:self.ListController to:self.omKistanController];
        [self menuBarToFront];
    }
    else if (product == YES){
        product = NO;
        kistan = YES;
        [self switchTo:self.pageViewController to:self.omKistanController];
        [self menuBarToFront];
    }
    else if (about == YES){
        about = NO;
        kistan = YES;
        [self switchTo:self.omOssController to:self.omKistanController];
        [self menuBarToFront];
    }
    else if (category == YES){
        category = NO;
        kistan = YES;
        [self switchTo:self.categoryController to:self.omKistanController];
        [self menuBarToFront];
    }
    else
    {
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
        button = NO;
    }
}

-(void)GoToCategory{
    if (list == YES) {
        list = NO;
        category = YES;
        [self switchTo:self.ListController to:self.categoryController];
        [self menuBarToFront];
    }
    else if (product == YES){
        product = NO;
        category = YES;
        [self switchTo:self.pageViewController to:self.categoryController];
        [self menuBarToFront];
    }
    else if (about == YES){
        about = NO;
        category = YES;
        [self switchTo:self.omOssController to:self.categoryController];
        [self menuBarToFront];
    }
    else if (kistan == YES){
        kistan = NO;
        category = YES;
        [self switchTo:self.omKistanController to:self.categoryController];
        [self menuBarToFront];
    }
    else
    {
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
        button = NO;
    }
}

#pragma mark - Buttons and menu

-(void)createListButtons{
    UIImage* priceSortIcon = [UIImage imageNamed:@"PRICE"];
   // priceSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    priceSort = [UIButton buttonWithType:UIButtonTypeCustom];
    priceSort.frame = CGRectMake(64, 20, 50, 50);
    
    [priceSort setImage:priceSortIcon forState:UIControlStateNormal];
    priceSort.titleLabel.font = [UIFont systemFontOfSize:20];
    [priceSort setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    priceSort.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    //[priceSort setTitle:@"$" forState:UIControlStateNormal];
    [priceSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceSort addTarget:self action:@selector(sortPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.ListController.view addSubview:priceSort];
    
    UIImage* AZ = [UIImage imageNamed:@"A-Z"];
    alphabeticSort = [UIButton buttonWithType:UIButtonTypeCustom];
    //alphabeticSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alphabeticSort.frame = CGRectMake(124, 20, 50, 50);
    
    alphabeticSort.titleLabel.font = [UIFont systemFontOfSize:20];
    [alphabeticSort setImage:AZ forState:UIControlStateNormal];
    [alphabeticSort setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    alphabeticSort.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
   // [alphabeticSort setTitle:@"A - Ö" forState:UIControlStateNormal];
    [alphabeticSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alphabeticSort addTarget:self action:@selector(sortAlphabetically) forControlEvents:UIControlEventTouchUpInside];
    [self.ListController.view addSubview:alphabeticSort];
}

-(void)setButton{
    button = NO;
    UIImage* MENU = [UIImage imageNamed:@"menu"];
       _dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
  //  _dropButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  //  [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
     [_dropButton setImage:MENU forState:UIControlStateNormal];
 
 //   [_dropButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
 //   _dropButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
 //   _dropButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [_dropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dropButton.frame = CGRectMake(self.view.frame.size.width-44, 20, 45, 45);
    [_dropButton addTarget:self action:@selector(DropMenu) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_dropButton];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(4, 20, 50, 50);
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(SearchIconPressed)
           forControlEvents:UIControlEventTouchUpInside];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20];
   // float size = 35;
  //  [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(size, size, size, size)];
    [self.view addSubview:_searchButton];
}

-(void)DropMenu{
    if(button == NO){
        [menu DropDownMenu];
        [_dropButton setTitle:@"▲" forState:UIControlStateNormal];
        [[menu omOssButton] addTarget:self action:@selector(GoToOmOss) forControlEvents:UIControlEventTouchUpInside];
        [[menu omKistanButton] addTarget:self action:@selector(GoToOmKistan) forControlEvents:UIControlEventTouchUpInside];
        [[menu categoryButton] addTarget:self action:@selector(GoToCategory) forControlEvents:UIControlEventTouchUpInside];
        [[menu productViewButton] addTarget:self action:@selector(GoToProductInfo) forControlEvents:UIControlEventTouchUpInside];
        [[menu listViewButton] addTarget:self action:@selector(GoToList) forControlEvents:UIControlEventTouchUpInside];
        
        button = YES;
    }
    else if (button == YES){
        [menu HideDownMenu];
        [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
         button = NO;
    }
}

-(void)menuBarToFront{
    [_dropButton setTitle:@"▼" forState:UIControlStateNormal];
    button = NO;
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_searchButton];
    [self.view bringSubviewToFront:_OursearchBar];
    
    
}

#pragma mark - Sorting indexs in tableView

-(void)sortAlphabetically{
    _JsonDataArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_JsonDataArray];
    
    if([_JsonDataArray count] == [_ForSearchArray count]){
      ShowAlphabet = YES;
    }
     [ourTableView reloadData];
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;

}

-(void)sortPrice{
    
    if(ascendingPrice == YES){
        ascendingPrice = NO;
    _JsonDataArray = [self ourSortingFunction:@"Utpris exkl moms" ascending:ascendingPrice withArray:_JsonDataArray];
    ShowAlphabet = NO;
    [ourTableView reloadData];
    
 
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;
        
    }else if (ascendingPrice == NO){
        ascendingPrice = YES;
        _JsonDataArray = [self ourSortingFunction:@"Utpris exkl moms" ascending:ascendingPrice withArray:_JsonDataArray];
        ShowAlphabet = NO;
        [ourTableView reloadData];
        
        self.pageViewController.dataSource = nil;
        self.pageViewController.dataSource = self;
    
    }
}

#pragma mark PageViewController
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_JsonDataArray count] == 0) ||( index >= [_JsonDataArray count])) {
        return nil;
    }
   // NSLog(@"%d",[[jsonData GetArray] count]);
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.arrayFromViewController = (NSMutableArray*)_JsonDataArray;
    

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
    if (index == [_JsonDataArray count]) {
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
    if(noResultsToDisplay == NO){
        return [_JsonDataArray count];
    }
    else if (noResultsToDisplay == YES){
        return 1;
    }else{
        return 0;
    }
}

//datan som en cell innehåller i min tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //används för identifiering
    static NSString *simpleTableIdentifier = @"myCell";
    //skapa en cell med identifieraren ovan
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    //denna kod används för inga resultat i sökningen
    if (noResultsToDisplay) {
        cell.textLabel.text = @"Inga träffar";
        cell.imageView.image = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }else{
    //om den inte är nil så allocera en ny cell, skapa med en stil och använd identifieraren ovan
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
    //ställ in texten i cellen
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.shadowColor =[UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(1, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.frame = CGRectMake(0,0,40 ,40);
    cell.contentMode = UIViewContentModeScaleAspectFill;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@ kr*",[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"],[_JsonDataArray[indexPath.row] objectForKey:@"Utpris exkl moms"]];
    
    //[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"];

    UIImage * imgFromMem =[jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]];
    
    if (imgFromMem != nil){
        cell.imageView.image = imgFromMem;
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUInteger row = [indexPath row];
    
    if (noResultsToDisplay) {
        //gör inget vid träff
        
    }else{
    [jsonData SetIndex:indexPath.row];
    
    [self goToPageIndex:(int)indexPath.row];
    self.pageViewController.dataSource = nil;
    self.pageViewController.dataSource = self;
    
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
                             
                                [_OursearchBar resignFirstResponder];
                                [UIView animateWithDuration:0.5 animations:^{
                                    _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
                                    _OursearchBar.alpha = 0;
                                } completion:^(BOOL finished) {
                                       _dropButton.hidden = NO;
                                }];
                            }];
    }
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
    NSString* first= [[_JsonDataArray[count]objectForKey:@"Artikelnamn"] substringToIndex:1];
    
    for (int i = 0; i< [_JsonDataArray count]; i++) {
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
#pragma mark - Category
-(void)startCategory{
    catY = 30;
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSString * finalPatch = [path stringByAppendingPathComponent:@"CategoryList.plist"];
    Categories = [NSDictionary dictionaryWithContentsOfFile:finalPatch];
    NSMutableArray * typeArray = [[NSMutableArray alloc] init];
    NSMutableArray * infoArray = [[NSMutableArray alloc] init];
    typeArray = [Categories objectForKey:@"Type"];
    infoArray = [Categories objectForKey:@"Info"];
    
    for (NSInteger i = 0; i<[typeArray count];  i++) {
        type = [typeArray objectAtIndex:i];
        info = [infoArray objectAtIndex:i];
        [self createCategoryHead];
        [self createCategoryBody];
    }
}

-(void)createCategoryHead{
    
    UILabel *CategoryInfo = [[UILabel alloc]initWithFrame:CGRectMake(20, catY, self.view.frame.size.width-40, 50)];
    CategoryInfo.text = type;
    CategoryInfo.numberOfLines = 1;
    CategoryInfo.font = [UIFont fontWithName:@"Arial" size:30];
    CategoryInfo.shadowColor =[UIColor blackColor];
    CategoryInfo.shadowOffset = CGSizeMake(1, 1);
    CategoryInfo.clipsToBounds = YES;
    CategoryInfo.backgroundColor = [UIColor clearColor];
    CategoryInfo.textColor = [UIColor whiteColor];
    CategoryInfo.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:CategoryInfo];
    catY = catY + 50;
}

-(void)createCategoryBody{
    UILabel *CategoryInfo = [[UILabel alloc]initWithFrame:CGRectMake(20, catY, self.view.frame.size.width-40, 200)];
    CategoryInfo.text = info;
    CategoryInfo.numberOfLines = 30;
    CategoryInfo.font = [UIFont fontWithName:@"Arial" size:13];
    CategoryInfo.shadowColor =[UIColor blackColor];
    CategoryInfo.shadowOffset = CGSizeMake(1, 1);
    CategoryInfo.clipsToBounds = YES;
    CategoryInfo.backgroundColor = [UIColor clearColor];
    CategoryInfo.textColor = [UIColor whiteColor];
    CategoryInfo.textAlignment = NSTextAlignmentLeft;
    [CategoryInfo sizeToFit];
    [scrollView addSubview:CategoryInfo];
    catY = catY + CategoryInfo.frame.size.height+20;
    
}

@end
