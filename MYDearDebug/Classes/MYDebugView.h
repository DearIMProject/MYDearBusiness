//
//  MYDebugView.h
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//  D 方块

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYDebugView : UIView

+ (instancetype)viewInWindow:(UIWindow *)window;

- (void)moveViewWithPoint:(CGPoint)point;

- (void)moveEnd;

@end

NS_ASSUME_NONNULL_END
