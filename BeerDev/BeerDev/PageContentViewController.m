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
    int sizeX;
    
    if(self.view.frame.size.height ==480){
        sizeX = self.view.frame.size.width-222;
    }else{
        sizeX = self.view.frame.size.width-195;
    }
    int sizeY   = self.view.frame.size.height-150;
    // Create a information view from our storyboard.
    self.displayImage = [[UIImageView alloc] init];
    self.displayImage.image = [UIImage imageNamed:@"placeholderbild"];
    self.displayImage.frame = CGRectMake((self.view.frame.size.width-sizeX)/2, 90, sizeX ,sizeY);
    
    [self.view addSubview:_displayImage];
    // Check if there is a image on disk with a pathname according the the name of the product.
    if([jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]] != nil){
        // Set the image to display from cache according to the page index and the products name.
        self.displayImage.image = [jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[_pageIndex] objectForKey:@"Artikelnamn"]]]];
    }
    else{
        // If there was no image on disk/cache start downloading the image.
        [self startDownload:(int)_pageIndex];
    }
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


-(void)setAlphaLevel:(float)alphaLevel{
    _displayImage.alpha = alphaLevel;
}


@end
