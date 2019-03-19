//
//  MiddleWareAction.h
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiddleWareAction : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSString *classMethod;

@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, copy) NSString *toState;     /// < 状态机

+ (MiddleWareAction *(^)(NSString *name))classMethod;

- (MiddleWareAction *(^)(NSDictionary *))params;
- (MiddleWareAction *(^)(NSString *))toStates;

@end

NS_ASSUME_NONNULL_END
