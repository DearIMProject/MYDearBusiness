//
//  MYDebugSectionModel.h
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import <Foundation/Foundation.h>
#import "MYDebugItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MYDebugSectionModel : NSObject

@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, strong) NSArray<MYDebugItemModel *> *itemModels; 

@end

NS_ASSUME_NONNULL_END
