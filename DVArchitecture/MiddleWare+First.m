//
//  MiddleWare+First.m
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import "MiddleWare+First.h"
#import "MiddleWareAction.h"
#import "MapCreator.h"

@implementation MiddleWare (First)

- (void)firstViewInVC:(UIViewController *)viewController
{
    [self _configMiddleWare];
    
    // 添加 factoryVC的按钮
    NSString *factoryTitle = self.dispatch(MiddleWareAction.classMethod(@"VCGeneratorCom stateVCTitle"));
    UIViewController *factoryVC = self.dispatch(MiddleWareAction.classMethod(@"VCGeneratorCom stateVC"));
    // publish按钮
    NSString *publishTitle = [self classMethod:@"VCGeneratorCom publishVCTitle"];
    UIViewController *publishVC = [self classMethod:@"VCGeneratorCom publishVC"];
    
    NSMutableDictionary *dic = MapCreator.create.key(@"factoryMethodButton").value(self.dispatch(MiddleWareAction.classMethod(@"ButtonCom configButton").params(MapCreator.create.key(@"text").value(factoryTitle).key(@"action").value(^{
        self.dispatch(MiddleWareAction.classMethod(@"FirstListCom pushVC").params(MapCreator.create.key(@"vc").value(viewController).key(@"toVc").value(factoryVC).done));
    }).done)))
    
    .key(@"publishButton").value(self.dispatch(MiddleWareAction.classMethod(@"ButtonCom configButton").params(MapCreator.create.key(@"text").value(publishTitle).key(@"action").value(^{
        self.dispatch(MiddleWareAction.classMethod(@"FirstListCom pushVC").params(MapCreator.create.key(@"vc").value(viewController).key(@"toVc").value(publishVC).done));
    }).done))).done;
    // 组装
    self.dispatch(MiddleWareAction.classMethod(@"FirstListCom viewInVC").params(dic).toStates(@"0"));
    self.dispatch(MiddleWareAction.classMethod(@"FirstListCom simRequest").params(MapCreator.create.key(@"action").value(^{
          NSLog(@"current state %@", self.toState);
    }).done));
}

- (void)firstViewAppear
{
    self.updateCurState([NSString stringWithFormat:@"%ld",self.toState.integerValue + 1]);
    NSLog(@"%@",self.toState);
    self.dispatch(MiddleWareAction.classMethod(@"FirstListCom diffStateShow"));
}

- (void)_configMiddleWare
{
    self.name(@"FirstListCom viewInVC").action(MiddleWareAction.classMethod(@"AopLogCom aopAppearLog"));
    self.name(@"VCGeneratorCom factoryMethodVCTitle").action(MiddleWareAction.classMethod(@"AopLogCom aopFactorySetTitle"));
}


@end
