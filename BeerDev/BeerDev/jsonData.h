//
//  jsonData.h
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-08.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jsonData : NSObject
/**
 * Calling this method will connect to the server and get the JSON file. Doing this sets the NSMutableArray but you have to get it with the GetArray Method.
 * @author Maxim Frisk
 *  * @return JSON NSMutableArray
 */
+(void)SetJSON;

/**
 * Get the NSMutableArray that contains the JSON file data. After recieving it you can use "getObjectForKey" to access the variables in the given index.
 * @author Maxim Frisk
 *  * @return JSON NSMutableArray
 */
+(NSMutableArray*)GetArray;

/**
 * Saves an NSMutableArray in NSUserDefaults with a key.
 * @author Maxim Frisk
 * @param NSMutableArray The NSMutableArray to save
 * @param NSString Key for the entry
 * @return nothing
 */
+(void)SetArrayForKey:(NSMutableArray*)jsonData forKey:(NSString*)key;

/**
 * Gets an NSMutableArray from NSUserDefaults for the given key
 * @author Maxim Frisk
 * @param NSString Key for the item to get from NSUserDefaults
 * @return the NSMutableArray
 */
+(NSMutableArray*)GetJsonArray:(NSString*)key;

/**
 * This method is for setting the array from memory insteed of calling the setJSON method. This method should not be called if the app is launched the first time. Use SetJSON then.  
 * @author Maxim Frisk
 * @param NSMutableArray
 * @return nothing
 */
+(void)SetArrayWithoutInternet:(NSMutableArray*)array;


//THIS METHODS IS NOT FINISHED
/**
 * Call this method when you want to cache all the images from the web.
 * @author Maxim Frisk
 */
+(void)CacheThoseImages;

@end
