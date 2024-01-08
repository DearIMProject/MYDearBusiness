//
//  MYDebugItemModel.m
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDebugItemModel.h"

@implementation MYDebugItemModel

+ (instancetype)modelWithName:(NSString *)itemName block:(ClickItemBlock)block {
    MYDebugItemModel *itemModel = [[MYDebugItemModel alloc] init];
    itemModel.itemName = itemName;
    itemModel.block = block;
    return itemModel;
}

@end
