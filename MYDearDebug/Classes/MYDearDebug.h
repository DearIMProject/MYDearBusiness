//
//  MYDearDebug.h
//  Pods
//
//  Created by APPLE on 2024/1/8.
//

#import <Foundation/Foundation.h>
#import "MYDebugSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

#define TheDebug MYDearDebug.defaultDebug

@interface MYDearDebug : NSObject

+ (instancetype)defaultDebug;

- (void)setupWithWindow:(UIWindow *)window;

- (BOOL)isShowDebug;

- (void)registDebugModule:(NSString *)moduleName moduleItmes:(NSArray<MYDebugItemModel *> *)moduleItems;

- (NSArray<MYDebugSectionModel *> *)models;

@end

NS_ASSUME_NONNULL_END
