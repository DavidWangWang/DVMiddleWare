//
//  MiddleWare.m
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import "MiddleWare.h"
#import "MiddleWareAction.h"

@interface MiddleWare()

@property (nonatomic,strong) NSMutableDictionary *middleWareMap; ///< action缓存
@property (nonatomic,strong) NSMutableDictionary *classes; ///< 对象的缓存
@property (nonatomic,strong) NSMutableDictionary *factories; ///< 变形器

@end

@implementation MiddleWare


- (MiddleWare * _Nonnull (^)(NSString * _Nonnull))name
{
    return ^MiddleWare *(NSString *name) {
        if (name.length < 1) return self;
        self.chainMiddleKey = name;
        return self;
    };
}

- (MiddleWare * _Nonnull (^)(MiddleWareAction * _Nonnull))action
{
    return ^MiddleWare *(MiddleWareAction *action) {
        if (!action) return self;
        NSMutableArray *objects = self.middleWareMap[self.chainMiddleKey];
        if (!objects) {
            objects = @[].mutableCopy;
            self.middleWareMap[self.chainMiddleKey] = objects;
        }
        [objects addObject:action];
        return self;
    };
}

- (MiddleWare * _Nonnull (^)(NSString * _Nonnull))updateCurState
{
    return ^MiddleWare *(NSString *state) {
        if (state.length > 0) {
            self.toState = state;
        }
        return self;
    };
}


#pragma mark - Action

- (id  _Nonnull (^)(MiddleWareAction * _Nonnull))dispatch
{
    return ^id (MiddleWareAction *action) {
        return [self dispatch:action];
    };
}

- (id)dispatch:(MiddleWareAction *)action
{
    if (action.toState.length > 0) {
        self.toState = action.toState;
    }
    return [self classMethod:action.classMethod parameters:action.parameters];
}

- (id)classMethod:(NSString *)classMethod
{
    return [self classMethod:classMethod parameters:nil];
}

- (id)classMethod:(NSString *)classMethod parameters:(NSDictionary *)params
{
    NSParameterAssert(classMethod);
    if (!classMethod) return nil;
    
    NSArray *classMethodItem = [classMethod componentsSeparatedByString:@" "];
    if (classMethodItem.count < 2) return nil;
    NSString *className = classMethodItem[0];
    NSString *methodName = classMethodItem[1];
    
    NSString *factory = [self.factories objectForKey:className];
    NSString *localClassMethod = nil;
    if (factory) {
        className = [NSString stringWithFormat:@"%@_factory_%@",className,factory];
        localClassMethod = [NSString stringWithFormat:@"%@ %@",className,methodName];
    }
    id action = self.middleWareMap[localClassMethod];
    if (action) {
        [self perform:action];
    }
    NSObject *objc = self.classes[className];
    if (objc) {
        objc = [[NSClassFromString(className) alloc]init];
        self.classes[className] = objc;
    }
    SEL method = NSSelectorFromString(methodName);
    if (![self.toState isEqualToString:@"init"]) {
         SEL stateMethod = NSSelectorFromString([NSString stringWithFormat:@"%@_state_%@:", methodName, self.toState]);
        if ([objc respondsToSelector:stateMethod]) {
            return [self executeMethod:stateMethod obj:objc params:params];
        }
    }
    SEL notFoundMethod = NSSelectorFromString(@"notFound");
    if ([objc respondsToSelector:notFoundMethod]) {
        return [self executeMethod:notFoundMethod obj:objc params:params];
    } else if ([objc respondsToSelector:method]) {
        return [self executeMethod:method obj:objc params:params];
    } else {
        [self.classes removeObjectForKey:className];
        return nil;
    }
    return nil;
}

- (void)perform:(id)action
{
    if ([action isKindOfClass:[MiddleWareAction class]]) {
        [self dispatch:action];
    } else if ([action isKindOfClass:[NSMutableArray class]]) {
        for (MiddleWareAction *act in action) {
            [self dispatch:act];
        }
    }
}

- (id)executeMethod:(SEL)stateMethod obj:(NSObject *)objc params:(NSDictionary *)params
{
    NSMethodSignature *signature = [NSMethodSignature methodSignatureForSelector:stateMethod];
    if (!signature) return nil;
    
    const char *returnTypes = [signature methodReturnType];
    if (strcmp(returnTypes, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:stateMethod];
        [invocation setTarget:objc];
        [invocation invoke];
        return nil;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [objc performSelector:stateMethod withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - Getter

// Getter
- (NSMutableDictionary *)classes {
    if (!_classes) {
        _classes = [[NSMutableDictionary alloc] init];
    }
    return _classes;
}

- (NSMutableDictionary *)middleWareMap
{
    if (!_middleWareMap) {
        _middleWareMap = @{}.mutableCopy;
    }
    return _middleWareMap;
}

- (NSMutableDictionary *)factories
{
    if (!_factories) {
        _factories = @{}.mutableCopy;
    }
    return _factories;
}

@end



