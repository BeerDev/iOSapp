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
    NSMutableArray * JsonDataArray;
    NSMutableArray * imageArray;
    int imageCount;
}
@end

@implementation TableView
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    JsonDataArray = [jsonData GetArray];
    tableViewArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    imageCount = 0;

    
    for (int i = 0; i < [JsonDataArray count]; i++){
        [tableViewArray addObject:[JsonDataArray[i] objectForKey:@"Artikelnamn"]];
        [imageArray addObject:[JsonDataArray[i] objectForKey:@"URL"]];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70) ];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = UIScrollViewIndicatorStyleWhite;
    
}
//anger hur många rader det är i min tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableViewArray count];
   
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
    cell.textLabel.text = [tableViewArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
    
    if([jsonData LoadFromDisk:[jsonData GetFilePath:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]]] == nil){
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]]];
            
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            
            if(image !=nil){
            
            [jsonData SetFilePath:[jsonData writeToDisc:image index:(int)indexPath.row] key:[[NSString alloc] initWithFormat:@"%@",[JsonDataArray[indexPath.row] objectForKey:@"Artikelnamn"]]];
            [jsonData writeToDisc:image index:(int)indexPath.row];
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
    UIViewController * mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    
    
        [self presentViewController:mainController animated:YES completion:^{
            self.view = nil;
        }];

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"accessory");
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



@end
