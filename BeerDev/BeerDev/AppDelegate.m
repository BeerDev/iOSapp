//
//  AppDelegate.m
//  BeerDev
//
//  Created by Maxim Frisk on 2014-03-28.
//  Copyright (c) 2014 beerDev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
 //   NSString *dirName = [docDir stringByAppendingPathComponent:@"MyDir"];
    NSString *tempDir = [docDir stringByAppendingPathComponent:@"imageCache"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:tempDir
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    
    NSURL *tempDirPathURL = [NSURL fileURLWithPath:tempDir];
    
    if ([jsonData addSkipBackupAttributeToItemAtURL:tempDirPathURL]) {
        NSLog(@"did add attribute!");
    } else {
        NSLog(@"adding attribute failed! :(");
    }
    
    NSLog(@"reachability in delegate %d",[jsonData connected]);
    if([jsonData connected] == YES && [jsonData GetDataOnline] != nil){
        NSLog(@"connection");
        [jsonData SetJSON:[jsonData GetDataOnline]];
        [jsonData SetArrayForKey:[jsonData GetArray] forKey:@"JSON"];
       // [jsonData GetDataOffline];
    }
    else if([jsonData connected] == YES && [jsonData GetDataOnline] == nil){
        if ([jsonData GetJsonArray:@"JSON"] == nil){
            // For offline in first start.
            [jsonData SetJSON:[jsonData GetDataOffline]];
        }
        else{
            [jsonData SetArrayWithoutInternet:[jsonData GetJsonArray:@"JSON"]];
        }
    }
    else if([jsonData connected] == NO){
        NSLog(@"no connection");
        
        if ([jsonData GetJsonArray:@"JSON"] == nil) {
            // For offline.
            [jsonData SetJSON:[jsonData GetDataOffline]];
        }
        else{
            [jsonData SetArrayWithoutInternet:[jsonData GetJsonArray:@"JSON"]];
        }
    }
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"entering background");
    [jsonData SetArrayForKey:[jsonData GetArray] forKey:@"JSON"];
    NSLog(@"count %lu",(unsigned long)[[jsonData GetArray] count]);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    
    if([jsonData connected] == YES){
        UIActivityIndicatorView *Indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        Indicator.center = self.window.rootViewController.view.center;
        Indicator.hidesWhenStopped = YES;
        [self.window.rootViewController.view addSubview:Indicator];
        [self.window.rootViewController.view bringSubviewToFront:Indicator];
        [Indicator startAnimating];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_group_t group = dispatch_group_create();
        
            dispatch_group_async(group, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"connection on enterForeground");
                [jsonData SetJSON:[jsonData GetDataOnline]];
                [jsonData SetArrayForKey:[jsonData GetArray] forKey:@"JSON"];
                [ViewController restartCache:YES];
            });
        });
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"done now");
                    [Indicator stopAnimating];
            });

            
            
        });
    }
    else{
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
