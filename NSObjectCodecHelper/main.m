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
        
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        NSDictionary *encodedPrim = [prim encodeToDictionary];
        NSString *encodedJsonStr = [encodedPrim encodeToJSONString];
        CFAbsoluteTime finish = CFAbsoluteTimeGetCurrent();
        NSLog(@"%lf", finish - start);
        
        start = CFAbsoluteTimeGetCurrent();
        NSDictionary *decodeFromJson = [encodedJsonStr jsonDecodeToDictionary];
        PrimitivesClass *decodedPrim = (PrimitivesClass *)[decodeFromJson codecObjectDecode];
        finish = CFAbsoluteTimeGetCurrent();
        NSLog(@"%lf", finish - start);
        
        NSLog(@"%@", decodedPrim);
    }
    return 0;
}
