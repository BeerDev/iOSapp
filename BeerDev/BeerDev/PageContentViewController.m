//
//  PageContentViewController.m
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-04.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController (){

    NSMutableArray * JsonDataArray; 
    
    
}
@end
@class ViewInformationController;

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //get the json array for setting the information in this class
    JsonDataArray = [jsonData GetArray];
    
    // Do any additional setup after loading the view.
    self.artikelnamnLabel.text = [JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"];
    
    self.priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr *", [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl. moms"]];
    
    self.infoLabel.text = [JsonDataArray[_pageIndex] objectForKey:@"Info"];

    [self startDownload:(int)_pageIndex];
    
    // check if you were on the information screen or not
    if (_informationIsShowing == YES) {
        NSLog(@"information was showing on the screen after or before the current view.");
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
   // NSLog(@"%@",[_jsonObjects[index] objectForKey:(NSString*)@"URL"]);
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    NSLog(@"finsihed");
    
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
    //calls information method which sets the information.
    //the reason why this is in a seperet method is that we want to call this in other situations
    [self information];

}
- (IBAction)closeInformationView:(id)sender {
    
    if(_informationIsShowing == YES){
        NSLog(@"pushed on screen");
        _informationIsShowing = NO;
        
        
        [UIView animateWithDuration:1 animations:^{_InformationController.view.alpha = 0.0;}
                         completion:^(BOOL finished){
                             [_InformationController.view removeFromSuperview];
                             NSLog(@"removed the information view");
                         }];

    }
}

#pragma mark important functions

-(void)information{
    
    if(_informationIsShowing == NO){
        _informationIsShowing = YES;
        NSLog(@"adding informationView");
        
        //set the ViewInformationController by storyboard ID.
        _InformationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewInformationController"];
        
        //set values for the information screen.
        _InformationController.name = [JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
        _InformationController.SEK = [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl. moms"];
        _InformationController.information = [JsonDataArray[_pageIndex] objectForKey:@"Info"];
         _InformationController.pro = [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"];
         _InformationController.size = [JsonDataArray[_pageIndex] objectForKey:@"Storlek"];
        
        
        
        //denna behövs egentligen inte just nu, men eventuellt i framtiden.
        _InformationController.pageIndex = _pageIndex;
        
        // Change the size of page view controller if needed.
        // self.ViewInformationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self addChildViewController:_InformationController];
        
        
        //this method is setting an animation for transaction between page and information
        [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ {
                            [self.view addSubview:_InformationController.view];
                        }
                        completion:^(BOOL finished){
                            NSLog(@"finished animation to information view");
                        }];
        }


}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
