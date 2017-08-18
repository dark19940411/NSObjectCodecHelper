//
//  PrimitivesClass.m
//  PrimitivesIvarAtRuntimeDemo
//
//  Created by turtle on 2017/8/15.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import "PrimitivesClass.h"

@interface PrimitivesClass (){
//    BOOL _ivarInExtension;
}

//@property(nonatomic, strong)NSObject *propInExt;
@property(nonatomic, copy)NSString *stringInExt;

@end

@implementation PrimitivesClass

- (instancetype)initWithInitialVals {
    self = [super init];
    if (self) {
        _intProp = -1;
        _uintProp = 1;
        _longProp = 2;
        _ulongProp = 22;
        _shortProp = 1;
        _ushortProp = 1;
        _longLongProp = 1;
        _ulongLongProp = 1;
        _charProp = 'a';
        _ucharProp = 'b';
        _boolProp = YES;
        _floatProp = 0.5;
        _doubleProp = 0.5;
        _stringInExt = @"test";
        _dateProp = [NSDate date];
    }
    return self;
}

- (void)createRecursiveIvar {
    _subProp = [[[self class] alloc] initWithInitialVals];
}

@end
