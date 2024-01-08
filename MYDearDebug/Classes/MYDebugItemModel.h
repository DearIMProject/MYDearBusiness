//
//  MYDebugItemModel.h
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickItemBlock)(void);

@interface MYDebugItemModel : NSObject

@property (nonatomic, strong) NSString *itemName;/**< 模块名称  */
@property(nonatomic, copy) ClickItemBlock block;/**< 点击回调  */

+ (instancetype)modelWithName:(NSString *)itemName block:(ClickItemBlock)block;

@end

NS_ASSUME_NONNULL_END
