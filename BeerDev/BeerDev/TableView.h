//
//  TableView.h
//  BeerDev
//
//  Created by Maxim Frisk on 2014-04-10.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jsonData.h"

@interface TableView : UITableViewController  <UITableViewDelegate, UITableViewDataSource>



//connection functions from NSURLConnection.
@property (nonatomic,retain) NSMutableArray* jsonObjects;
@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end
