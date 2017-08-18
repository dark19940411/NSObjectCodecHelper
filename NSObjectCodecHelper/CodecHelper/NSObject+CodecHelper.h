//
//  NSObject+CodecHelper.h
//  wpsoffice
//
//  Created by Turtle on 2017/8/15.
//  Copyright © 2017年 Kingsoft Office. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CodecHelper)

- (NSDictionary *)encodeToDictionary;

@end

@interface NSDictionary (CodecHelper)

- (NSString *)encodeToJSONString;
- (instancetype)codecObjectDecode;

@end

@interface NSString (CodecHelper)

- (NSDictionary *)jsonDecodeToDictionary;

@end
