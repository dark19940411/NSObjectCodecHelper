//
//  PrimitivesClass.h
//  PrimitivesIvarAtRuntimeDemo
//
//  Created by turtle on 2017/8/15.
//  Copyright © 2017年 turtle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrimitivesClass : NSObject

@property (nonatomic, assign)int intProp;
@property (nonatomic, assign)unsigned int uintProp;
@property (nonatomic, assign)long longProp;
@property (nonatomic, assign)unsigned long ulongProp;
@property (nonatomic, assign)short shortProp;
@property (nonatomic, assign)unsigned short ushortProp;
@property (nonatomic, assign)long long longLongProp;
@property (nonatomic, assign)unsigned long long ulongLongProp;
@property (nonatomic, assign)char charProp;
@property (nonatomic, assign)unsigned char ucharProp;
@property (nonatomic, assign)bool boolProp;
@property (nonatomic, assign)float floatProp;
@property (nonatomic, assign)double doubleProp;
//@property (nonatomic, assign)long double longDoubleProp;
//@property (nonatomic, assign)CGPoint cgpointProp;
//@property (nonatomic, assign)CGRect cgrectProp;
//@property (nonatomic, assign)CGAffineTransform cgafTransformProp;
@property (nonatomic, strong)PrimitivesClass *subProp;
@property (nonatomic, strong)NSDate *dateProp;

- (instancetype)initWithInitialVals;
- (void)createRecursiveIvar;

@end
