//
//  MapCreator.h
//  DVArchitecture
//
//  Created by David on 2019/3/19.
//  Copyright © 2019年 WHYIOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapCreator : NSObject

+ (MapCreator *)create;

- (MapCreator *(^)(NSString *))key;
- (MapCreator *(^)(id))value;

- (NSMutableDictionary *)done;

@end

NS_ASSUME_NONNULL_END
