//
//  TableView.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-10.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "TableView.h"

@interface TableView (){
    
    //global variables
    NSMutableArray * tableViewArray;
    NSMutableArray * array;
    NSMutableArray * imageArray;
}
@end

@implementation TableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    array = [jsonData GetArray];
    tableViewArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++){
        NSString * temp = [array[i] objectForKey:@"Artikelnamn"];
      // NSLog(@"%@",temp);
        [tableViewArray addObject:temp];
        [self startDownload:i];
    }
    //[tableViewArray addObject:nil];
   //  NSLog(@"%@",tableViewArray);
 
}
//anger hur många rader det är i min tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableViewArray count];
   
}

//datan som en cell innehåller i min tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //används för identifiering
    static NSString *simpleTableIdentifier = @"myTableView";
    
    //skapa en cell med identifieraren ovan
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //om den inte är nil så allocera en ny cell, skapa med en stil och använd identifieraren ovan
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //ställ in texten i cellen
    cell.textLabel.text = [tableViewArray objectAtIndex:indexPath.row];
    cell.imageView.image = [imageArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startDownload:(int)index{
    self.activeDownload = [NSMutableData data];
    // NSLog(@"%@",[_jsonObjects[index] objectForKey:(NSString*)@"URL"]);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[array[index] objectForKey:(NSString*)@"URL"]]];
    
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
    
    if(image!= nil){
        [imageArray addObject:image];
    }
  
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
    
}

@end
