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
    int imageCount;
}
@end

@implementation TableView
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    array = [jsonData GetArray];
    tableViewArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    imageCount = 0;

    
    for (int i = 0; i < [array count]; i++){
        [tableViewArray addObject:[array[i] objectForKey:@"Artikelnamn"]];
        [imageArray addObject:[array[i] objectForKey:@"URL"]];
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
    static NSString *simpleTableIdentifier = @"myCell";
    

    
    //skapa en cell med identifieraren ovan
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    

    //om den inte är nil så allocera en ny cell, skapa med en stil och använd identifieraren ovan
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    //ställ in texten i cellen
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [tableViewArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"placeholderbild"];
  //  cell.imageView.image = image;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
      //  UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[cell imageView] setImage:image];
            [cell setNeedsLayout];
        });
    });
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUInteger row = [indexPath row];
  
    NSLog(@"you pressed %@",[tableViewArray objectAtIndex:indexPath.row]);
    
    
    UIViewController * mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [jsonData SetIndex:indexPath.row];
    
        [self presentViewController:mainController animated:YES completion:^{
            self.view = nil;
        }];
 //
    //UIAlertView * ourmessage = [[UIAlertView alloc] initWithTitle:@"BEER" message:@"this is beer" delegate:nil cancelButtonTitle:@"dont press here" otherButtonTitles:@"this is another button", nil ];
   // [ourmessage show];
    
    // In viewDidLoad you would have set up an array of controllers, then:
  //  UIViewController *childController = [tableViewArray objectAtIndex:row];
  //  [self.navigationController pushViewController:childController];
   
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"accessory");
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



@end
