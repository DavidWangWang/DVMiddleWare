//
//  MiddleWareAction.m
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import "MiddleWareAction.h"

@implementation MiddleWareAction

- (MiddleWareAction * _Nonnull (^)(NSDictionary * _Nonnull))params
{
    return ^MiddleWareAction *(NSDictionary *params) {
        self.parameters = params.mutableCopy;
        return self;
    };
}

- (MiddleWareAction * _Nonnull (^)(NSString * _Nonnull))toState
{
    return ^MiddleWareAction * (NSString *toState) {
        self.toState = toState;
        return self;
    };
}

@end
