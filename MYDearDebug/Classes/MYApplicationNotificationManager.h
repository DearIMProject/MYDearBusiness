//
//  MYApplicationNotificationManager.h
//  MYDearApplication
//
//  Created by APPLE on 2023/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYApplicationNotificationManager : NSObject

+ (instancetype)shared;

- (void)setup;

@end

NS_ASSUME_NONNULL_END
