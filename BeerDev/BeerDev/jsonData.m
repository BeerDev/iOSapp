//
//  jsonData.m
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-08.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import "jsonData.h"

@implementation jsonData

static NSMutableArray* JSONARRAY = nil;
static NSCache * myImageCache;
//@synthesize jsonObjects = _jsonObjects;

-(id)init {
    if (self = [super init]) {
       
    }
    return self;
}

+(void)SetJSON{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://beerdev.tk/json.php"]];
    JSONARRAY = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
}

+(NSMutableArray*)GetArray{
    return JSONARRAY;
}

+(void)SetArrayForKey:(NSMutableArray*)jsonData forKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:jsonData forKey:key];
		[standardUserDefaults synchronize];
	}

}

+(NSMutableArray*)GetJsonArray:(NSString*)key
{
    NSMutableArray* jsonData = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]){
        jsonData = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:key];
    }
    return jsonData;
}

+(void)SetArrayWithoutInternet:(NSMutableArray*)array{
    JSONARRAY = array;
}


+(void)SetIndex:(NSInteger)index{

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
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
    //[myImageCache setCountLimit:2];
    NSLog(@"%d",(int)[myImageCache countLimit]);
}

+(void)SetCacheItemForKey:(UIImage*)image forKey:(NSString*)key{
    [myImageCache setObject:image forKey:key];

}

+(UIImage*)GetCachedImage:(NSString*)forKey{
    UIImage * cachedImage = [myImageCache objectForKey:forKey];
    
    return cachedImage;
}




+(NSString*)writeToDisc:(UIImage*)img index:(int)index{
   
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"Documents/img%d.png",index]];
    
    NSData * myImage =UIImagePNGRepresentation(img);
    [myImage writeToFile:path atomically:YES];
    NSLog(@"path %@",path);

    return path;

}

+(UIImage*)LoadFromDisk:(NSString*)path{
 //   NSLog(@"file to get %@",path);
    NSData* imageData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}


+(void)SetFilePath:(NSString*)path key:(NSString*)key{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:path forKey:key];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)GetFilePath:(NSString*)key{
    NSString* path = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]){
        path = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return path;
}



+ (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}



@end
