//
//  NSObject+CodecHelper.h
//  wpsoffice
//
//  Created by Turtle on 2017/8/15.
//  Copyright © 2017年 Kingsoft Office. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CodecHelper)

/**
 Convert a given object to a dictionary. Mapping ivarName: value as key: value.

 @return Encoded dictionary.
 */
- (NSDictionary *)encodeToDictionary;

@end

@interface NSDictionary (CodecHelper)

/**
 Convert a dictionary to JSON string.

 @return Converted JSON string.
 */
- (NSString *)encodeToJSONString;
/**
 Convert a dictionary to an object belongs to a specific class which is in current context. If that class is not load into current context, this method will simply return nil.

 @return A decoded method.
 */
- (instancetype)codecObjectDecode;

@end

@interface NSString (CodecHelper)

/**
 Decode a JSON string to an NSDictionary.

 @return A decoded dictionay.
 */
- (NSDictionary *)jsonDecodeToDictionary;

@end
