//
//  main.m
//  PrimitivesIvarAtRuntimeDemo
//
//  Created by turtle on 2017/8/15.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "PrimitivesClass.h"
#import "NSObject+CodecHelper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        PrimitivesClass *prim = [[PrimitivesClass alloc] initWithInitialVals];
        [prim createRecursiveIvar];
        
        NSDictionary *encodedPrim = [prim encodeToDictionary];
        NSLog(@"encodedDictionary:\n %@", encodedPrim);
        
        NSString *encodedJsonStr = [encodedPrim encodeToJSONString];
        NSLog(@"encodedJsonStr:\n %@", encodedJsonStr);
        
        NSDictionary *decodeFromJson = [encodedJsonStr jsonDecodeToDictionary];
        NSLog(@"decodeFromJson:\n %@", decodeFromJson);
        
        PrimitivesClass *decodedPrim = (PrimitivesClass *)[decodeFromJson codecObjectDecode];
        
        NSLog(@"decodedPrim:\n %@", decodedPrim);
    }
    return 0;
}
