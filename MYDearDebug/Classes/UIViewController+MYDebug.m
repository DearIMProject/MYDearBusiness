//
//  UIViewController+MYDebug.m
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import "UIViewController+MYDebug.h"
#import <objc/runtime.h>
#import "MYDearDebug.h"
#import "MYDebugView.h"
#import "MYDebugViewController.h"

@interface MYDearDebug (MYDebugCategory)

@property (nonatomic, strong) MYDebugView *debugView;

@end

@interface UIViewController ()

@property (nonatomic, assign) BOOL isInDebugTouchBegin;/**< 点击开始  */
@property (nonatomic, assign) BOOL hasDebugMove;/**< 是否move  */

@end

@implementation UIViewController (MYDebug)

- (MYDebugView *)debugView {
    return MYDearDebug.defaultDebug.debugView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!MYDearDebug.defaultDebug.isShowDebug) {
        return;
    }
    CGPoint point = [touches.anyObject locationInView:MYDearDebug.defaultDebug.debugView];
    BOOL isInDebugView = CGRectContainsPoint(self.debugView.bounds, point);
    self.isInDebugTouchBegin = isInDebugView;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!MYDearDebug.defaultDebug.isShowDebug) {
        return;
    }
    if (self.isInDebugTouchBegin) {
        self.hasDebugMove = YES;
        CGPoint movePoint = [touches.anyObject locationInView:self.view];
        [[self debugView] moveViewWithPoint:movePoint];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!MYDearDebug.defaultDebug.isShowDebug) {
        return;
    }
    if (self.isInDebugTouchBegin) {
        [[self debugView] moveEnd];
        self.isInDebugTouchBegin = NO;
        if (!self.hasDebugMove) {
            //TODO: wmy 跳转到debug页面
            MYDebugViewController *modalViewController = [[MYDebugViewController alloc] init];
//
//            // 创建导航控制器并设置根视图控制器为要显示的视图控制器
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:modalViewController];
//
//            // 取消操作
//            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain
//                                                                            target:modalViewController
//                                                                            action:@selector(dismissModalViewController)];
//            modalViewController.navigationItem.leftBarButtonItem = cancelButton;
            
            // 模态显示
            [self.navigationController pushViewController:modalViewController animated:YES];
        }
        self.hasDebugMove = NO;
    }
}

#pragma mark - getter and setter

- (void)setHasDebugMove:(BOOL)hasDebugMove {
    objc_setAssociatedObject(self, @selector(hasDebugMove), @(hasDebugMove), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasDebugMove {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsInDebugTouchBegin:(BOOL)isInDebugTouchBegin {
    objc_setAssociatedObject(self, @selector(isInDebugTouchBegin), @(isInDebugTouchBegin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (BOOL)isInDebugTouchBegin {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
