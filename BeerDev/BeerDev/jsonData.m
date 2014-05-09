//
//  jsonData.m
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-08.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import "jsonData.h"

@implementation jsonData
static NSArray* JSONARRAY = nil;
static NSCache * myImageCache;

+(NSData *)GetDataOnline{
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://beerdev.info/sortiment.json"] options:NSDataReadingMappedAlways error:&error];
    NSLog(@"error %@",error);
    if(error){
        return [self GetDataOffline];
    }
    
    return jsonData;
}

+(NSData *)GetDataOffline{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPatch = [path stringByAppendingPathComponent:@"json.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:finalPatch];
    return jsonData;
}

+(void)SetJSON:(NSData *)data{
    NSError *error = nil;
    id jsonObjects;
    jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if(error){
    jsonObjects = [NSJSONSerialization JSONObjectWithData:[self GetDataOffline] options:NSJSONReadingMutableContainers error:&error];
    }
    //NSLog(@"%@" ,error);
    // Define keys
    NSString *info = @"Info";
    NSString *url = @"URL";
    NSString *price = @"Utpris";
    NSString *brewery = @"Bryggeri";
    NSString *name = @"Artikelnamn";
    NSString *alc = @"Alkoholhalt";
    NSString *size = @"Storlek";
    NSString *category = @"Kategori";
    NSString *barcode = @"Streckkod";
    
    // Create array to hold dictionaries
    NSMutableArray *myObject = [[NSMutableArray alloc] init];
    // Values in foreach loop
    for (NSDictionary *dataDict in jsonObjects){
        NSString *artikelnamn = [dataDict objectForKey:name];
        NSString *bild = [dataDict objectForKey:url];
        NSNumber *pris =  [dataDict objectForKey:price];
        NSString *bryggeri = [dataDict objectForKey:brewery];
        NSString *information = [dataDict objectForKey:info];
        NSString *alkohol = [dataDict objectForKey:alc];
        NSString *kategori =[dataDict objectForKey:category];
        NSString *storlek =[dataDict objectForKey:size];
        NSString *streckkod =[dataDict objectForKey:barcode];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              artikelnamn, name,
                              bild, url,
                              pris, price,
                              bryggeri, brewery,
                              information, info,
                              alkohol, alc,
                              kategori, category,
                              storlek, size,
                              streckkod, barcode,
                              nil];
        [myObject addObject:dict];
    }
    JSONARRAY = myObject;
}

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    NSLog(@"excluding");
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success =  [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    
    if(!success){
       NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+(NSArray*)GetArray{
    return JSONARRAY;
}

+(void)SetArrayForKey:(NSMutableArray *)jsonData forKey:(NSString *)key{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if(standardUserDefaults){
		[standardUserDefaults setObject:jsonData forKey:key];
		[standardUserDefaults synchronize];
	}
}

+(NSArray *)GetJsonArray:(NSString *)key{
    NSArray *jsonData = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:key]){
        jsonData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key];
    }
    return jsonData;
}

+(void)SetArrayWithoutInternet:(NSMutableArray*)array{
    JSONARRAY = array;
}

+(void)SetIndex:(NSInteger)index{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if(standardUserDefaults){
		[standardUserDefaults setInteger:index forKey:@"index"];
		[standardUserDefaults synchronize];
	}
}

+(NSInteger)GetIndex{
    NSInteger myIndex = 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"index"]){
        myIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"index"];
    }
    return myIndex;
}

+(void)SetCache{
    myImageCache = [[NSCache alloc] init];
}

+(void)SetCacheItemForKey:(UIImage *)image forKey:(NSString *)key{
    [myImageCache setObject:image forKey:key];
}

+(UIImage *)GetCachedImage:(NSString *)forKey{
    UIImage *cachedImage = [myImageCache objectForKey:forKey];
    
    return cachedImage;
}

+(NSString *)writeToDisc:(NSData*)img name:(NSString *)name{
    NSString *path = nil;
    //write a path only if there is an image
    if(img != nil){
        path = [NSHomeDirectory() stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"Documents/imageCache/%@.png",name]];
        //NSData *myImage =UIImagePNGRepresentation(img);
        [img writeToFile:path atomically:YES];
    }
    return path;
}

+(UIImage *)LoadFromDisk:(NSString *)path{
    UIImage *image = nil;
    if(path !=nil){
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

+(void)SetFilePath:(NSString *)path key:(NSString *)key{
    if(path != nil){
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults){
            [standardUserDefaults setObject:path forKey:key];
            [standardUserDefaults synchronize];
        }
    }
}

+(NSString *)GetFilePath:(NSString *)key{
    NSString *path = nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:key]){
        path = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return path;
}

+ (void)removeImage:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success){
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
    }
    else{
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

+(BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

@end
