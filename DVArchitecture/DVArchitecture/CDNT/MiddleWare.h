//
//  MiddleWare.h
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MiddleWareAction;
NS_ASSUME_NONNULL_BEGIN

@interface MiddleWare : NSObject

@property (nonatomic, copy) NSString *chainMiddleKey;
@property (nonatomic, copy) NSString *toState;     /// < 状态机


- (MiddleWare *(^)(NSString *))name;
- (MiddleWare *(^)(MiddleWareAction *))action;

- (id (^)(MiddleWareAction *))dispatch;
- (id)classMethod:(NSString *)classMethod;

- (MiddleWare *(^)(NSString *))updateCurState;

@end

NS_ASSUME_NONNULL_END
