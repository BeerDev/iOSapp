//
//  PageContentViewController.m
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-04.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import "PageContentViewController.h"
#import "constans.h"

@interface PageContentViewController(){
    //this is used to hold the JSON data.
    NSArray * JsonDataArray;
    NSInteger Ycord;
    UILabel * nameLabel;
    UILabel * priceLabel;
    UILabel * infoLabel;
}

@end

@class ViewInformationController;

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

- (void)viewDidLoad{
    [super viewDidLoad];
    JsonDataArray =  _arrayFromViewController;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.displayImage.image = [UIImage imageNamed:@"placeholderbild"];
    // Create a information view from our storyboard.
    _InformationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewInformationController"];
    [self addChildViewController:_InformationController];
    // Check if there is a image on disk with a pathname according the the name of the product.
    if([jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]] != nil){
        // Set the image to display from cache according to the page index and the products name.
        self.displayImage.image = [jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]]];
    }
    else{
        // If there was no image on disk/cache start downloading the image.
        [self startDownload:(int)_pageIndex];
    }
    [self createLabel];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - download connection

- (void)startDownload:(int)index{
    self.activeDownload = [NSMutableData data];
    //starting the request from  URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[JsonDataArray[index] objectForKey:(NSString*)@"URL"]]];
    // alloc+init and start an NSURLConnection; release on completion/failure.
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	// Clear the activeDownload property to allow later attempts.
    self.activeDownload = nil;
    // Release the connection now that it's finished.
    self.imageConnection = nil;
    self.displayImage.image = [UIImage imageNamed:@"placeholderbild"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Set appIcon and clear temporary data/image.
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    // Save the image to disk and save a path in userdefaults with name.
    
    if(image == NULL){
        self.activeDownload = nil;
        // Release the connection now that it's finished.
        self.imageConnection = nil;
        
        // Call our delegate and tell it that our icon is ready for display.
        if (self.completionHandler)
            self.completionHandler();
    }else{
        self.displayImage.image = image;
        // [jsonData SetFilePath:[jsonData writeToDisc:image name:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]] key:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]]
        self.activeDownload = nil;
        // Release the connection now that it's finished.
        self.imageConnection = nil;
        // Call our delegate and tell it that our icon is ready for display.
        if (self.completionHandler)
            self.completionHandler();
    }
}

#pragma mark - Gesture Recognizer functions

- (IBAction)SetInformationView:(id)sender{
    // If the information is not showing set the information view.
    // Calls information method which sets the information.
    if(_informationIsShowing == NO){
        NSLog(@"adding informationView");
        _informationIsShowing = YES;
        
        nameLabel.hidden = YES;
        priceLabel.hidden = YES;
        infoLabel.hidden = YES;
        self.displayImage.alpha = 0.45;
        // Set values for the information screen.
        _InformationController.name = [JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
        _InformationController.SEK = [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"];
        _InformationController.information = [JsonDataArray[_pageIndex] objectForKey:@"Info"];
        _InformationController.pro = [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"];
        _InformationController.size = [JsonDataArray[_pageIndex] objectForKey:@"Storlek"];
        _InformationController.brygg = [JsonDataArray[_pageIndex] objectForKey:@"Bryggeri"];
        _InformationController.kategori = [JsonDataArray[_pageIndex] objectForKey:@"Kategori"];
        _InformationController.pageIndex = _pageIndex;
        _InformationController.view.alpha = 0;
        
        [self.view addSubview:_InformationController.view];
        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 1;}
                         completion:^(BOOL finished){
                         }];
    }

}

- (IBAction)tap:(id)sender {
    if(_informationIsShowing == NO){
        NSLog(@"adding informationView");
        _informationIsShowing = YES;
        
        nameLabel.hidden = YES;
        priceLabel.hidden = YES;
        infoLabel.hidden = YES;
        self.displayImage.alpha = 0.45;
        // Set values for the information screen.
        _InformationController.name = [JsonDataArray[_pageIndex]objectForKey:@"Artikelnamn"];
        _InformationController.SEK = [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"];
        _InformationController.information = [JsonDataArray[_pageIndex] objectForKey:@"Info"];
        _InformationController.pro = [JsonDataArray[_pageIndex] objectForKey:@"Alkoholhalt"];
        _InformationController.size = [JsonDataArray[_pageIndex] objectForKey:@"Storlek"];
        _InformationController.brygg = [JsonDataArray[_pageIndex] objectForKey:@"Bryggeri"];
        _InformationController.kategori = [JsonDataArray[_pageIndex] objectForKey:@"Kategori"];
        _InformationController.pageIndex = _pageIndex;
        _InformationController.view.alpha = 0;
        
        [self.view addSubview:_InformationController.view];
        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 1;}
                         completion:^(BOOL finished){
                         }];
    }
    else if(_informationIsShowing == YES){
        _informationIsShowing = NO;

        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 0.0;self.displayImage.alpha = 1;}
                         completion:^(BOOL finished){
                             [_InformationController.view removeFromSuperview];
                             nameLabel.hidden = NO;
                             priceLabel.hidden = NO;
                             infoLabel.hidden = NO;
                         }];
    }
}

- (IBAction)downSwipe:(id)sender {
    // If the information is showing remove it with animation.
    if(_informationIsShowing == YES){
        _informationIsShowing = NO;
        
        [UIView animateWithDuration:0.5 animations:^{_InformationController.view.alpha = 0.0;self.displayImage.alpha = 1;}
                         completion:^(BOOL finished){
                             [_InformationController.view removeFromSuperview];
                             nameLabel.hidden = NO;
                             priceLabel.hidden = NO;
                             infoLabel.hidden = NO;
                         }];
    }
    
}
-(void)labelTemplet:(UILabel *)label{
    // Create template.
    label.textColor = [UIColor whiteColor];
    label.shadowColor =[UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1) ;
    label.textAlignment = NSTextAlignmentLeft;
}
- (void) createLabel{
    Ycord = 430;    
    // Create name label.
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-90, 50)];
    nameLabel.text= [JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"];
    [self labelTemplet:nameLabel];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];
    nameLabel.numberOfLines = 0;
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    // Create price label.
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, Ycord, self.view.frame.size.width-40, 50)];
    priceLabel.text = [[NSString alloc]initWithFormat:@"%@ kr*", [JsonDataArray[_pageIndex] objectForKey:@"Utpris exkl moms"]];
    [self labelTemplet:priceLabel];
    priceLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:17];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [priceLabel sizeToFit];
    [self.view addSubview:priceLabel];
    Ycord = Ycord + nameLabel.frame.size.height+30;
    // Create information label.
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Ycord, self.view.frame.size.width-40, 50)];
    infoLabel.text =[JsonDataArray[_pageIndex] objectForKey:@"Info"];
    [self labelTemplet:infoLabel];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    infoLabel.numberOfLines = 2;
    [self.view addSubview:infoLabel];
}

@end
