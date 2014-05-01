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
    //bakgrundsbilden
    UIImageView *backgroundView ;
    //offset som ska användas för scrollning av bilden
    float offset;
    
    //knappar för att sortera listan
    UIButton* priceSort;
    UIButton* alphabeticSort;
    
    //en instans av våran meny.
    DDMenu*menu;
    //variabler som håller koll på vilken sida du är på/går till.
    BOOL about;
    BOOL kistan;
    BOOL category;
    BOOL list;
    BOOL product;
    
    //används för att hålla koll på scrollning
    BOOL didbegin;
    
    //används för att hjälpa till med sorteringen.
    BOOL ShowAlphabet;
    BOOL ascendingPrice;
    BOOL thereIsResults;
    
    BOOL button;
    BOOL noResultsToDisplay;
    BOOL allowToPress;
    
    PageContentViewController *startingViewController;
    NSArray *viewControllers;
    NSArray *indexTitle;

    UIImage *magnifierCross;
    UIImage *magnifier;
    UIImage *heart;
    UIImage *heartFilled;
    //table
    UITableView *ourTableView;

    NSArray * searchResults;
    
    //For Category
    UIScrollView * ourScrollView;
    NSMutableDictionary *Categories;
    NSInteger catY;
    NSString *type;
    NSString *info;
    int taggen;
    NSMutableArray * typeArray;
    NSArray *tempArray;
    
    
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
    heart = [UIImage imageNamed:@"smallnotfilled"];
    heartFilled = [UIImage imageNamed:@"smallHeartFilled"];
    //this array is used for searching and caching images
    _ForSearchArray = [jsonData GetArray];
    _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];

    //this array is used to display the current filtered products
    _JsonDataArray = [jsonData GetArray];
    _JsonDataArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_JsonDataArray];

   // _MyFav = [[NSMutableArray alloc] init];
    
    [self setButton];
    [self cacheEverything];
    
    //set backgroundcolor
    self.view.backgroundColor = [UIColor whiteColor];
    backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundView];
    ShowAlphabet = YES;
    allowToPress = YES;

    
    
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
    self.pageViewController.delegate = self;
    //[jsonData SetIndex:0];

    // Change the size of page view controller if needed.
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    // Set page that is showing
    product = YES;
    tempArray = [[NSArray alloc] init];
    //[jsonData SetIndex:1];
    
    [self goToPageIndex:0];
    
    // menu and buttons

    menu = [[DDMenu alloc ]initWithFrame:CGRectMake( self.view.frame.size.width+220, 0, 220, self.view.frame.size.height)];
    [self.view addSubview:menu];
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_OursearchBar];
    [self.view bringSubviewToFront:_searchButton];
    [self.view bringSubviewToFront:_cancelSearch];
    

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
    for (UIView *v in self.pageViewController.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)v).delegate = self;
        }
    }
    
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
    _OursearchBar.searchBarStyle = UISearchBarStyleMinimal;


     UIView* view=_OursearchBar.subviews[0];
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
    
    //Category
    ourScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70)];
    ourScrollView.backgroundColor = [UIColor clearColor];
    ourScrollView.showsHorizontalScrollIndicator = NO;
    ourScrollView.showsVerticalScrollIndicator = YES;
    [ourScrollView setShowsVerticalScrollIndicator:NO];
    [ourScrollView setShowsHorizontalScrollIndicator:NO];
    [self.categoryController.view  addSubview:ourScrollView];
    [ourScrollView setScrollEnabled:YES];
    [self startCategory];
    
    //en lyssnartråd! :D
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        int temp = 0;
        while (temp <1) {
            temp++;
            [NSThread sleepForTimeInterval:30];
           
            _ForSearchArray = [jsonData GetArray];
            _ForSearchArray = [self ourSortingFunction:@"Artikelnamn" ascending:YES withArray:_ForSearchArray];
            temp--;
        }
    });
    
    alphabeticSort.hidden = YES;
    priceSort.hidden = YES;
    
    
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
    tempArray = searchResults;
    [ourTableView reloadData];
    }
    else if ([searchResults count] ==0 && product == YES){
        _JsonDataArray = tempArray;
        noResultsToDisplay = NO;
        
        
    }
    else if ([searchResults count] ==0 && list == YES){
    _JsonDataArray = nil;

    noResultsToDisplay = YES;
    [ourTableView reloadData];
        
    }
    if([searchText isEqualToString:@""]){
        noResultsToDisplay = NO;
        _JsonDataArray = _ForSearchArray;
        [ourTableView reloadData];
    }
    
    if(product == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
        [self dataSource];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self animateButton:_dropButton Hidden:NO Alpa:1];
    if(list == YES){
    [self animateButton:alphabeticSort Hidden:NO Alpa:1];
    [self animateButton:priceSort Hidden:NO Alpa:1];
    }
    //denna kod kollar vad som ska hända när man har tryckt på "sök" knappen.
    //om du har resultat gå in i denna if-sats
    if([_JsonDataArray count]<=[_ForSearchArray count] && [_JsonDataArray count]>0 ){
        
        //animera bort sökfältet och fixa till med datasourcen.
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
        if(list == YES){
        [self animateButton:_cancelSearch Hidden:NO Alpa:1];
        }
        
        //fixa BILDEN
        //om du dessutom är på "produkt" vyn och får sökträffar gör denna kod.
            if(product == YES && [_JsonDataArray count] >0 && [_JsonDataArray count]<[_ForSearchArray count]){
                [self dataSource];
                [self animateButton:_cancelSearch Hidden:NO Alpa:1];
                }
        
        //om du inte får några träffar på produkt vyn gör detta kod.
            else if(product == YES && [_JsonDataArray count] == [_ForSearchArray count]){
            
                [self noResultsAlert];
                searchBar.text = nil;
                [self dataSource];
                [self animateButton:_searchButton Hidden:NO Alpa:1];
        }
        
    }
    
    //gör denna else om du inte har några träffar i listvyn.
        else{
        [searchBar resignFirstResponder];
        ShowAlphabet = YES;
        [self animateButton:_searchButton Hidden:NO Alpa:1];
        [self noResultsAlert];
        
            //special animation with options.
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
    //fix buttons
    [self animateButton:_dropButton Hidden:NO Alpa:1];
    [self animateButton:_searchButton Hidden:NO Alpa:1];
    if(list == YES){
    [self animateButton:alphabeticSort Hidden:NO Alpa:1];
    [self animateButton:priceSort Hidden:NO Alpa:1];
    }
    
    if([_JsonDataArray count]<=[_ForSearchArray count]){
        
        searchBar.text = nil;
        ShowAlphabet = YES;
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
        noResultsToDisplay = NO;
        _JsonDataArray = _ForSearchArray;
        [ourTableView reloadData];
        
            if(product == YES && [_JsonDataArray count] != 0){
                [self dataSource];
            }
    }
    else {
        
        searchBar.text = nil;
        ShowAlphabet = YES;
        [searchBar resignFirstResponder];
        [self searchBarAnimationUp];
    }
}

-(void)dataSource{
    startingViewController = [self viewControllerAtIndex:0];
    viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        _pageViewController.dataSource = nil;
        _pageViewController.dataSource = self;
    }];
}

-(void)searchBarAnimationUp{
    NSDate *startDate = [NSDate date];

    [UIView animateWithDuration:0.5 animations:^{
        _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
        _OursearchBar.alpha = 0;
    }
     
                     completion:^(BOOL finished) {

                       //  self.pageViewController.dataSource = nil;
                       //  self.pageViewController.dataSource = self;
                             NSLog(@"search bar time %f", [[NSDate date] timeIntervalSinceDate:startDate]);
                         
    }];
}



-(void)noResultsAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Din sökning gav inga träffar"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //titta på detta senare!!
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
}




-(void)SearchIconPressed{

    [self animateButton:_dropButton Hidden:YES Alpa:0];
    [self animateButton:_searchButton Hidden:YES Alpa:0];
    [self animateButton:alphabeticSort Hidden:YES Alpa:0];
    [self animateButton:priceSort Hidden:YES Alpa:0];
    
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

-(void)SearchCancel{
    [self animateButton:_cancelSearch Hidden:YES Alpa:0];
    [self animateButton:_searchButton Hidden:NO Alpa:1];
    _JsonDataArray = _ForSearchArray;

   
    _OursearchBar.text = nil;
    //table view
    ShowAlphabet = YES;
    noResultsToDisplay = NO;

    [ourTableView reloadData];
    [self dataSource];


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
                
             //  NSLog(@"returns? %d", [jsonData addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:[_ForSearchArray[i]objectForKey:@"URL"]]]);
                
                
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

- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - Switching between views.

- (void)switchTo:(UIViewController*)from to:(UIViewController *)controller
{
  
    [self transitionFromViewController:from
                      toViewController: controller
                              duration:0.0
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                          // no animation necessary, but docs say this can't be NULL
                            }
                            completion:^(BOOL finished){
                                
                                [menu HideDownMenu:self.view.frame.size.width];
                                [self slideAllViews];
                                [self.view bringSubviewToFront:_OursearchBar];
                                [self menuBarToFront];
                                
            }];
    if(product == YES || list == YES){
          _searchButton.hidden = NO;
    }else{
        _searchButton.hidden = YES;
    }
    
    if(list == YES){
        alphabeticSort.hidden = NO;
        priceSort.hidden = NO;
    }else{
            alphabeticSort.hidden = YES;
            priceSort.hidden = YES;
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
        [menu HideDownMenu:self.view.frame.size.width];
        button = NO;
        [self slideAllViews];
        [self menuBarToFront];
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
        [menu HideDownMenu:self.view.frame.size.width];
        button = NO;
        [self slideAllViews];
        [self menuBarToFront];
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
        [menu HideDownMenu:self.view.frame.size.width];
        button = NO;
        [self slideAllViews];
        [self menuBarToFront];
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
        [menu HideDownMenu:self.view.frame.size.width];
        button = NO;
        [self slideAllViews];
        [self menuBarToFront];
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
        [menu HideDownMenu:self.view.frame.size.width];
        button = NO;
        [self slideAllViews];
        [self menuBarToFront];
    }
}

#pragma mark - Buttons and menu

-(void)createListButtons{
    UIImage* priceSortIcon = [UIImage imageNamed:@"Pris"];
   // priceSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    priceSort = [UIButton buttonWithType:UIButtonTypeCustom];
    priceSort.frame = CGRectMake(64, 20, 55, 55);
    
    [priceSort setImage:priceSortIcon forState:UIControlStateNormal];
    priceSort.titleLabel.font = [UIFont systemFontOfSize:20];
    [priceSort setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    priceSort.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    //[priceSort setTitle:@"$" forState:UIControlStateNormal];
    [priceSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priceSort addTarget:self action:@selector(sortPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priceSort];
    
    UIImage* AZ = [UIImage imageNamed:@"A-Z"];
    alphabeticSort = [UIButton buttonWithType:UIButtonTypeCustom];
    //alphabeticSort = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alphabeticSort.frame = CGRectMake(124, 20, 55, 55);
    
    alphabeticSort.titleLabel.font = [UIFont systemFontOfSize:20];
    [alphabeticSort setImage:AZ forState:UIControlStateNormal];
    [alphabeticSort setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    alphabeticSort.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
   // [alphabeticSort setTitle:@"A - Ö" forState:UIControlStateNormal];
    [alphabeticSort setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alphabeticSort addTarget:self action:@selector(sortAlphabetically) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alphabeticSort];
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
    _dropButton.frame = CGRectMake(self.view.frame.size.width-55, 20, 55, 55);
    [_dropButton addTarget:self action:@selector(DropMenu) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_dropButton];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(4, 20, 55, 55);
    [_searchButton setImage:magnifier forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(SearchIconPressed)
           forControlEvents:UIControlEventTouchUpInside];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20];
   // float size = 35;
  //  [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(size, size, size, size)];
    [self.view addSubview:_searchButton];
    
    _cancelSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelSearch.frame = CGRectMake(4, 20, 55, 55);
    [_cancelSearch setImage:magnifierCross forState:UIControlStateNormal];
    [_cancelSearch addTarget:self action:@selector(SearchCancel)
            forControlEvents:UIControlEventTouchUpInside];
    _cancelSearch.titleLabel.font = [UIFont systemFontOfSize:20];
    // float size = 35;
    //  [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(size, size, size, size)];
    [self.view addSubview:_cancelSearch];
    _cancelSearch.hidden = YES;
    
}

-(void)DropMenu{
  
    if(button == NO && allowToPress == YES){
          allowToPress = NO;
        
        [self animateButton:_searchButton Hidden:YES Alpa:0];
        [self animateButton:alphabeticSort Hidden:YES Alpa:0];
        [self animateButton:priceSort Hidden:YES Alpa:0];
        [self animateButton:_cancelSearch Hidden:YES Alpa:0];
    

        
        [menu DropDownMenu:self.view.frame.size.width];
        [[menu omOssButton] addTarget:self action:@selector(GoToOmOss) forControlEvents:UIControlEventTouchUpInside];
        [[menu omKistanButton] addTarget:self action:@selector(GoToOmKistan) forControlEvents:UIControlEventTouchUpInside];
        [[menu categoryButton] addTarget:self action:@selector(GoToCategory) forControlEvents:UIControlEventTouchUpInside];
        [[menu productViewButton] addTarget:self action:@selector(GoToProductInfo) forControlEvents:UIControlEventTouchUpInside];
        [[menu listViewButton] addTarget:self action:@selector(GoToList) forControlEvents:UIControlEventTouchUpInside];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.pageViewController.view.frame = CGRectMake(-self.pageViewController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
            self.ListController.view.frame = CGRectMake(-self.ListController.view.frame.size.width, 0,  self.ListController.view.frame.size.width,  self.ListController.view.frame.size.height);

            self.omKistanController.view.frame = CGRectMake(-self.omKistanController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

            self.omOssController.view.frame = CGRectMake(-self.omOssController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

            self.categoryController.view.frame = CGRectMake(-self.categoryController.view.frame.size.width, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);

        } completion:^(BOOL finished) {
            allowToPress= YES;
        }];
        
        button = YES;
    }
    else if (button == YES && allowToPress == YES){
        allowToPress = NO;
        
        [menu HideDownMenu:self.view.frame.size.width];
         button = NO;
        
        if([_JsonDataArray count]<[_ForSearchArray count]){
            thereIsResults = YES;
        }else{
            thereIsResults = NO;
        }
        
        
        if( (list == YES  && thereIsResults == NO) || (product == YES && thereIsResults == NO)){
            [self animateButton:_searchButton Hidden:NO Alpa:1];
        }else if(thereIsResults == YES){
            [self animateButton:_cancelSearch Hidden:NO Alpa:1];
        }
        if(list== YES){
            [self animateButton:alphabeticSort Hidden:NO Alpa:1];
            [self animateButton:priceSort Hidden:NO Alpa:1];
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
    button = NO;
    [self.view bringSubviewToFront:menu];
    [self.view bringSubviewToFront:_dropButton];
    [self.view bringSubviewToFront:_searchButton];
    [self.view bringSubviewToFront:_OursearchBar];
    [self.view bringSubviewToFront:_cancelSearch];
    [self.view bringSubviewToFront:alphabeticSort];
    [self.view bringSubviewToFront:priceSort];
    
    if([_JsonDataArray count]<[_ForSearchArray count]){
        thereIsResults = YES;
    }else{
        thereIsResults = NO;
    }
    
    
    if( (list == YES  && thereIsResults == NO) || (product == YES && thereIsResults == NO)){
        [self animateButton:_searchButton Hidden:NO Alpa:1];
    }else if((list == YES && thereIsResults == YES) || (product == YES && thereIsResults == YES)){
        [self animateButton:_cancelSearch Hidden:NO Alpa:1];
    }
    if(list== YES){
        [self animateButton:alphabeticSort Hidden:NO Alpa:1];
        [self animateButton:priceSort Hidden:NO Alpa:1];
    }
}

-(void)slideAllViews{
    [UIView animateWithDuration:0.5 animations:^{
        self.pageViewController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        self.ListController.view.frame = CGRectMake(0, 0,  self.ListController.view.frame.size.width,  self.ListController.view.frame.size.height);
        
        self.omKistanController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
        self.omOssController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
        self.categoryController.view.frame = CGRectMake(0, 0,  self.pageViewController.view.frame.size.width,  self.pageViewController.view.frame.size.height);
        
    } completion:^(BOOL finished) {

    }];

}

-(void)animateButton:(UIButton*)Button Hidden:(BOOL)yesOrNo Alpa:(int)zeroOrOne{
    
    if(Button.hidden == YES){
        Button.hidden = yesOrNo;
        
        //UIButton
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

    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.arrayFromViewController = (NSMutableArray*)_JsonDataArray;
    
    //didGoToNextPage = NO;
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(!completed ){
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
        
    /*
        if([self checkIfInFav:[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]] == NO){
            NSLog(@"fanns ej");
            
            UIButton* addToFav = [UIButton buttonWithType:UIButtonTypeCustom];
            //[addToFav setTitle:@"add" forState:UIControlStateNormal];
            [addToFav setImage:heart forState:UIControlStateNormal];
            [addToFav setTag:[indexPath row]];
            addToFav.frame = CGRectMake(255,51,50,50);
            [addToFav addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addToFav];
        }else{
            NSLog(@"fanns");
            UIButton* removeFromFav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
           // [removeFromFav setTitle:@"remove" forState:UIControlStateNormal];
            [removeFromFav setImage:heartFilled forState:UIControlStateNormal];
            [removeFromFav setTag:[indexPath row]];
            removeFromFav.frame = CGRectMake(255,51,50,50);
            [removeFromFav addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:removeFromFav];
        }
     */
    
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
    //ställ in texten i cellen
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@ kr* %@",[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"],[_JsonDataArray[indexPath.row] objectForKey:@"Utpris exkl moms"],[_JsonDataArray[indexPath.row] objectForKey:@"Kategori"]];
    
    //[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"];

    UIImage * imgFromMem =[jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[_JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]];
    
    if (imgFromMem != nil){
        cell.imageView.image = imgFromMem;
        }
        
    }
    return cell;
}
/*
-(BOOL)checkIfInFav:(NSString*)artikelnamnet{
    NSLog(@"artikelnamn att jämföra med %@",artikelnamnet);
    for(int i =0;i<[_MyFav count]; i++){
        NSLog(@"myfav array %@",[_MyFav[i] objectForKey:@"Artikelnamn"]);
        
        if([[_MyFav[i] objectForKey:@"ArtikelNamn"] isEqualToString:artikelnamnet]){
            NSLog(@"hittade %@",[_MyFav[i] objectForKey:@"ArtikelNamn"]);
            return YES;
        }
    }
    return NO;
}

-(void)favButtonClicked:(UIButton *)sender{
    
   BOOL isinfav = [self checkIfInFav:[[_JsonDataArray objectAtIndex:sender.tag] objectForKey:@"Artikelnamn"]];
    if (isinfav == NO) {
        [_MyFav addObject:[_JsonDataArray objectAtIndex:sender.tag]];
        NSLog(@"%@",_MyFav);
    }
    
}
*/


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUInteger row = [indexPath row];
    
    if (noResultsToDisplay) {
        //gör inget vid träff
        
    }else{
    [jsonData SetIndex:indexPath.row];
    
    [self goToPageIndex:(int)indexPath.row];
        alphabeticSort.alpha = 0 ;
        alphabeticSort.hidden = YES;
        priceSort.alpha = 0 ;
        priceSort.hidden = YES;

        
        
    [self transitionFromViewController:self.ListController
                      toViewController: self.pageViewController
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                                   // no animation necessary, but docs say this can't be NULL
                               }
                            completion:^(BOOL finished){
                                list = NO;
                                product = YES;
                                [menu HideDownMenu:self.view.frame.size.width];
                                [self menuBarToFront];
                                [self viewWillDisappear:NO];
                                [self animateButton:_dropButton Hidden:NO Alpa:1];
                                

                                [_OursearchBar resignFirstResponder];
                                [UIView animateWithDuration:0.5 animations:^{
                                    _OursearchBar.frame = CGRectMake(0, -100,  self.view.frame.size.width, 78);
                                    _OursearchBar.alpha = 0;
                                    
                                } completion:^(BOOL finished) {
                                   
                                    //   _dropButton.hidden = NO;
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

    

    NSLog(@"%d",count);
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


#pragma mark - extra
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  //  NSLog(@"lala");
    if(product == YES && didbegin == NO ){
        didbegin =YES;
        [_OursearchBar resignFirstResponder];
    }
    else if(list == YES && didbegin == NO ){
        didbegin =YES;
        [_OursearchBar resignFirstResponder];
    }
    _contentOffsetInPage = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    didbegin = NO;


}


//EJ FÄRDIG KOD HÄR
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(product == YES){
        ScrollDirection scrollDirection;
        if (_contentOffsetInPage > scrollView.contentOffset.x){
            scrollDirection = ScrollDirectionRight;

        }
        else if (_contentOffsetInPage < scrollView.contentOffset.x){
            scrollDirection = ScrollDirectionLeft;

 //       offset=(scrollView.contentOffset.x)/4;
        }
        
  //  _contentOffsetInPage = scrollView.contentOffset.x;
  //  backgroundView.frame = CGRectMake(320-offset, 0, self.view.frame.size.width, self.view.frame.size.height);

    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake && product == YES) {
        NSLog(@"shake");
        [self goToPageIndex:(int)[self getRandomNumberBetween:0 maxNumber:[_JsonDataArray count]-1]];
    }

}
- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

#pragma mark - Category
-(void)startCategory{
    catY = 0;
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSString * finalPatch = [path stringByAppendingPathComponent:@"CategoryList.plist"];
    Categories = [NSDictionary dictionaryWithContentsOfFile:finalPatch];
    typeArray = [[NSMutableArray alloc] init];
    NSMutableArray * infoArray = [[NSMutableArray alloc] init];
    typeArray = [Categories objectForKey:@"Type"];
    infoArray = [Categories objectForKey:@"Info"];
    
    for (int i = 0; i<[typeArray count];  i++) {
        taggen = i;
        type = [typeArray objectAtIndex:i];
        info = [infoArray objectAtIndex:i];
        [self createCategoryHead];
        [self createCategoryBody];
    }
}

-(void)createCategoryHead{
    UIButton * categoryInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
  
/*
    UILabel *CategoryInfo = [[UILabel alloc]initWithFrame:CGRectMake(20, catY, self.view.frame.size.width-40, 50)];
    CategoryInfo.text = type;
    CategoryInfo.numberOfLines = 1;
    CategoryInfo.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
    CategoryInfo.shadowColor =[UIColor blackColor];
    CategoryInfo.shadowOffset = CGSizeMake(1, 1);
    // CategoryInfo.clipsToBounds = YES;
    CategoryInfo.backgroundColor = [UIColor clearColor];
    CategoryInfo.textColor = [UIColor whiteColor];
    CategoryInfo.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:CategoryInfo];
    catY = catY + 50;
 */
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
  
    _JsonDataArray = [_ForSearchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Kategori ==[c] %@", [typeArray objectAtIndex:(int)sender.tag]]];
    
    ShowAlphabet = NO;
    [ourTableView reloadData];
   
    [self GoToList];
    [self dataSource];

}


@end
