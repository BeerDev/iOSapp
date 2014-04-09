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

//@synthesize jsonObjects = _jsonObjects;

-(id)init {
    if (self = [super init]) {
       
    }
    return self;
}

+(void)SetJSON{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://beerdev.tk/json_products.php"]];
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

+(void)CacheThoseImages{


}

@end
