//
//  jsonData.h
//  pageViewController
//
//  Created by Maxim Frisk on 2014-04-08.
//  Copyright (c) 2014 Maxim Frisk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@interface jsonData : NSObject
+(NSData*)GetDataOffline;
+(NSData*)GetDataOnline;
/**
 * Calling this method will connect to the server and get the JSON file. Doing this sets the NSMutableArray but you have to get it with the GetArray Method.
 * @author Maxim Frisk
 *  * @return JSON NSMutableArray
 */
+(void)SetJSON:(NSData*)data;

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


//THIS METHODS IS NOT FINISHED //Write descriptions!!


/**
 * This method sets the index on which bottle the user should be presented with.
 * @author Maxim Frisk
 * @param Integer The index integer.
 * @return Nothing
 */
+(void)SetIndex:(NSInteger)index;

/**
 * This method gets the index on the current integer saved for which bottle you should go to.
 * @author Maxim Frisk
 * @return Integer The index integer
 */
+(NSInteger)GetIndex;

/**
 * Calling this method sets a temporare cache and initialises it.
 * @author Maxim Frisk
 */
+(void)SetCache;

/**
 * Call this method to save an image to the temporare cache for a key. The key is usually the URL link to the image.
 * @author Maxim Frisk
 * @param Image The image you want to save
 * @param Key The key for the image
 * @return index
 */
+(void)SetCacheItemForKey:(UIImage*)image forKey:(NSString*)key;


/**
 * Calling this method with a key, checks if there is an image for the corresponding key.
 * @author Maxim Frisk
 * @param NSMutableArray
 * @return index
 */
+(UIImage*)GetCachedImage:(NSString*)forKey;

//


//write to file and get from file
+(NSString*)writeToDisc:(UIImage*)img index:(int)index name:(NSString*)name;
+(UIImage*)LoadFromDisk:(NSString*)url;
+(void)SetFilePath:(NSString*)path key:(NSString*)key;
+(NSString*)GetFilePath:(NSString*)key;

//connection
+(BOOL)connected;

//skip icloud backup
//+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


@end
