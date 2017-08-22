//
//  NSObject+CodecHelper.m
//  wpsoffice
//
//  Created by Turtle on 2017/8/15.
//  Copyright © 2017年 Kingsoft Office. All rights reserved.
//

#import "NSObject+CodecHelper.h"
#import <objc/runtime.h>

#pragma mark - Encode

#define CLASS_NAME_KEY @"Turtle.CodecHelper.__class_name_key"

#define kSetDicSafely(dict, key, value)                                                                                \
    if (value) {                                                                                                       \
        dict[(key)] = value;                                                                                           \
    }
static bool isPrimitives(Ivar ivar) {
    const char* type = ivar_getTypeEncoding(ivar);
    NSString *typeStr = [NSString stringWithUTF8String:type];
    if ([typeStr containsString:@"@\""]) {
        return false;
    }
    return true;
}

NSNumber * getPrimitivesValue(id object, Ivar ivar) {
    const char* type = ivar_getTypeEncoding(ivar);
    if(type[0] == 'c') {       //char
        char val = ((char (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithChar:val];
    }
    else if(type[0] == 'C'){       //unsigned char
        unsigned char val = ((unsigned char (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithUnsignedChar:val];
    }
    else if(type[0] == 'B'){
        bool val = ((bool (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithBool:val];
    }
    else if(type[0] == 's'){
        short val = ((short (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithShort:val];
    }
    else if(type[0] == 'S'){
        unsigned short val = ((unsigned short (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithUnsignedShort:val];
    }
    else if(type[0] == 'i'){
        int val = ((int (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithInt:val];
    }
    else if(type[0] == 'I'){
        unsigned int val = ((unsigned int (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithUnsignedInt:val];
    }
    else if(type[0] == 'q'){
        long long val = ((long long (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithLongLong:val];
    }
    else if(type[0] == 'Q'){
        unsigned long long val = ((unsigned long long (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithUnsignedLongLong:val];
    }
    else if(type[0] == 'f'){
        float val = ((float (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithFloat:val];
    }
    else if(type[0] == 'd'){
        double val = ((double (*)(id, Ivar))object_getIvar)(object, ivar);
        return [NSNumber numberWithDouble:val];
    }
    return nil;
}

@implementation NSObject (CodecHelper)

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *m_dict = [NSMutableDictionary dictionary];
    
    NSString *className = NSStringFromClass([self class]);
    [m_dict setObject:className forKey:CLASS_NAME_KEY];
    
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList([self class], &numIvars);
    
    for (int i = 0; i < numIvars; ++i) {
        Ivar thisIvar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        bool isPrim = isPrimitives(thisIvar);
        
        id value = nil;
        if (isPrim) {
            value = getPrimitivesValue(self, thisIvar);
        }
        else {
            value = object_getIvar(self, thisIvar);
        }
        
        if ([[value class] conformsToProtocol:@protocol(NSSecureCoding)]) {
            if ([value isKindOfClass:[NSDate class]]) {
                NSDate *date = value;
                NSTimeInterval timeInterval = [date timeIntervalSince1970];
                value = [NSNumber numberWithDouble:timeInterval];
            }
            [m_dict setObject:value forKey:key];
        }
        else {
            NSDictionary *tempDic = [value encodeToDictionary];
            kSetDicSafely(m_dict, key, tempDic);
        }
    }
    
    free(ivars);
    
    return [m_dict copy];
}

@end

#pragma mark - Decode
static NSMutableSet<NSString *> *kDateIvarNames = nil;

NSSet<NSString *> *getIvarsNamesSet(Class class) {
    unsigned int numIvars = 0;
    Ivar *ivars = class_copyIvarList(class, &numIvars);
    NSMutableSet *m_set = [NSMutableSet set];
    for (int i = 0; i < numIvars; ++i) {
        Ivar thisIvar = ivars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        const char *type = ivar_getTypeEncoding(thisIvar);
        //Specifically handle with NSDate object 
        if (strcmp(type, "@\"NSDate\"") == 0) {
            if (!kDateIvarNames) { kDateIvarNames = [NSMutableSet set]; }
            [kDateIvarNames addObject:name];
        }
        [m_set addObject:name];
    }
    return [m_set copy];
}

@implementation NSDictionary (CodecHelper)

- (NSString *)encodeToJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (instancetype)codecObjectDecode {
    if ([[self allKeys] containsObject:CLASS_NAME_KEY]) {
        Class class = NSClassFromString([self objectForKey:CLASS_NAME_KEY]);
        if (!class) { return nil; }
        id object = [[class alloc] init];
        NSSet *set = getIvarsNamesSet(class);
        for (NSString *key in self.allKeys) {
            if (![set containsObject:key]) { continue; }
            id value = self[key];
            
            //Judge if a dictionary is an object encoded by NSObjectCodecHelper, decoding it if it is or simply assign it to the ivar on the contrary.
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temp = value;
                if ([temp.allKeys containsObject:CLASS_NAME_KEY]) {
                    value = [temp codecObjectDecode];
                }
            }
            
            //Deal With NSDate Object
            if (kDateIvarNames && [kDateIvarNames containsObject:key]) {
                NSNumber *timeIntervalNum = (NSNumber *)value;
                value = [NSDate dateWithTimeIntervalSince1970:timeIntervalNum.doubleValue];
            }
            
            [object setValue:value forKey:key];
        }
        return object;
    }
    return nil;
}

@end

#pragma mark - JSON String to Dictionary
@implementation NSString (CodecHelper)

- (NSDictionary *)jsonDecodeToDictionary {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

@end
