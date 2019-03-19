//
//  MiddleWare+First.h
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import "MiddleWare.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiddleWare (First)

- (void)firstViewInVC:(UIViewController *)viewController;
- (void)firstViewAppear;

@end

NS_ASSUME_NONNULL_END
