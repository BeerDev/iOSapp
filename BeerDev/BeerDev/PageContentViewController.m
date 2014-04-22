//
//  PageContentViewController.m
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-04.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import "PageContentViewController.h"
#import "constans.h"

@interface PageContentViewController (){
    //this is used to hold the JSON data.
    NSArray * JsonDataArray;
}
@end
@class ViewInformationController;

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // we are currently not using this method
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];

    //sort the jsondata before presenting the pageview.
    //get the json array for setting the information in this class
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"Artikelnamn" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];

    JsonDataArray = [[jsonData GetArray] sortedArrayUsingDescriptors:sortDescriptors];

    //create a information view from our storyboard
    _InformationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewInformationController"];
    [self addChildViewController:_InformationController];

    //set the name,price and info from the JSON data according to the pageIndex
    self.artikelnamnLabel.text = [JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"];
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr *", [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"]];
    self.infoLabel.text = [JsonDataArray[_pageIndex] objectForKey:@"Info"];
    
    /*---------------------------------------------------------------------------------*/
    //check if there is a image on disk with a pathname according the the name of the product.
    if([jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]]] != nil){
           NSLog(@"there was a file on disk");
        //set the image to display from cache according to the page index and the products name.
        self.displayImage.image = [jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]]];
    }
    else
    {
        //if there was no image on disk/cache start downloading the image.
        [self startDownload:(int)_pageIndex];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - download connection
- (void)startDownload:(int)index{
    self.activeDownload = [NSMutableData data];
    //starting the request from  URL
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[JsonDataArray[index] objectForKey:(NSString*)@"URL"]]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    // Release the connection now that it's finished
    self.imageConnection = nil;
    self.displayImage.image = [UIImage imageNamed:@"placeholderbild"];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
   
    //save the image to disk and save a path in userdefaults with name.
    [jsonData SetFilePath:[jsonData writeToDisc:image index:(int)_pageIndex] key:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]];
    [jsonData writeToDisc:image index:(int)_pageIndex];
        self.displayImage.image = image;
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();

}

#pragma mark - Gesture Recognizer functions
- (IBAction)SetInformationView:(id)sender {
    //if the information is not showing set the information view.
    //calls information method which sets the information.
    if(_informationIsShowing == NO){
        NSLog(@"adding informationView");
        _informationIsShowing = YES;
        
        self.artikelnamnLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.infoLabel.hidden = YES;
        self.displayImage.alpha = 0.45;
        
        //set values for the information screen.
        _InformationController.name = [JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
        _InformationController.SEK = [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"];
        _InformationController.information = [JsonDataArray[_pageIndex] objectForKey:@"Info"];
        _InformationController.pro = [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"];
        _InformationController.size = [JsonDataArray[_pageIndex] objectForKey:@"Storlek"];
        _InformationController.brygg = [JsonDataArray[_pageIndex] objectForKey:@"Bryggeri"];
        _InformationController.kategori = [JsonDataArray[_pageIndex] objectForKey:@"Kategori"];
        
        //denna behövs egentligen inte just nu, men eventuellt i framtiden.
        _InformationController.pageIndex = _pageIndex;
        
        _InformationController.view.alpha = 0;
        [self.view addSubview:_InformationController.view];
        
        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 1;}
                         completion:^(BOOL finished){
                             NSLog(@"klar");
                         }];
    }

}

- (IBAction)downSwipe:(id)sender {
    //if the information is showing remove it with animation.
    if(_informationIsShowing == YES){
        _informationIsShowing = NO;
        
        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 0.0;self.displayImage.alpha = 1;}
                         completion:^(BOOL finished){
                             [_InformationController.view removeFromSuperview];
                             self.artikelnamnLabel.hidden = NO;
                             self.priceLabel.hidden = NO;
                             self.infoLabel.hidden = NO;
                             }];
    }

}

@end
