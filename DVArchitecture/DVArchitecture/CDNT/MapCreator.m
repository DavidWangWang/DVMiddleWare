//
//  MapCreator.m
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import "MapCreator.h"

@interface MapCreator()

@property (nonatomic, copy) NSString *chainKey;
@property (nonatomic,strong) NSMutableDictionary *params; ///< <#a#>

@end

@implementation MapCreator

+ (MapCreator *)create
{
    return [[self alloc]init];
}

- (MapCreator * _Nonnull (^)(NSString * _Nonnull))key
{
    return ^MapCreator *(NSString *key) {
        self.chainKey = key;
        return self;
    };
}

- (MapCreator * _Nonnull (^)(id _Nonnull))value
{
    return ^MapCreator *(id value) {
        self.params[self.chainKey] = value;
        return self;
    };
}

- (NSMutableDictionary *)done
{
    NSMutableDictionary *result = self.params.mutableCopy;
    self.params = @{}.mutableCopy;
    return result;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = @{}.mutableCopy;
    }
    return _params;
}


@end
