//
//  MYDearDebug.m
//  Pods
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDearDebug.h"
#import "MYDebugView.h"
#import "MYDebugSectionModel.h"
#import "MYDebugViewController.h"
#import <MYDearApplication/MYApplicationManager.h>

@interface MYDearDebug ()

@property (nonatomic, strong) MYDebugView *debugView;
@property (nonatomic, assign) BOOL isShowDebug;
@property (nonatomic, strong) NSMutableArray<MYDebugSectionModel *> *sectionModels;
@property (nonatomic, assign) BOOL isInDebugView;


@end

@implementation MYDearDebug

+ (instancetype)defaultDebug {
    static dispatch_once_t onceToken;
    static MYDearDebug * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MYDearDebug alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShowDebug = YES;
        _sectionModels = [NSMutableArray array];
    }
    return self;
}

- (void)setupWithWindow:(UIWindow *)window {
    //TODO: wmy 将“D”添加到屏幕上
    _debugView = [MYDebugView viewInWindow:window];
    UITapGestureRecognizer *windowTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(onTap:)];
    windowTap.delegate = self;
    [window addGestureRecognizer:windowTap];
    UIPanGestureRecognizer *windowPan = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(onPan:)];
    windowPan.delegate = self;
    [window addGestureRecognizer:windowPan];
    _debugView.layer.zPosition = 100;
}

- (void)onTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.debugView];
    BOOL isInDebugView = CGRectContainsPoint(self.debugView.bounds, point);
    if (isInDebugView) {
        MYDebugViewController *modalViewController = [[MYDebugViewController alloc] init];
        [TheApplication.navi pushViewController:modalViewController animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class]) {
//        NSLog(@"gestureRecognizer isKindOfClass:UITapGestureRecognizer.class");
        CGPoint point = [touch locationInView:self.debugView];
        BOOL isInDebugView = CGRectContainsPoint(self.debugView.bounds, point);
        if (isInDebugView) {
            return YES;
        }
    }
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
//        NSLog(@"gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class");
        CGPoint point = [gestureRecognizer locationInView:self.debugView];
//        NSLog(@"state = %d",gestureRecognizer.state);
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            BOOL isInDebugView = CGRectContainsPoint(self.debugView.bounds, point);
            return isInDebugView;
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged ||
            gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            return _isInDebugView;
        }
        return _isInDebugView;
    }
    return NO;
}

- (void)onPan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.debugView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isInDebugView = CGRectContainsPoint(self.debugView.bounds, point);
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (_isInDebugView) {
            CGPoint movePoint = [gesture locationInView:self.debugView.superview];
            [[self debugView] moveViewWithPoint:movePoint];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isInDebugView = NO;
        [self.debugView moveEnd];
    }
}

- (void)registDebugModule:(NSString *)moduleName moduleItmes:(NSArray<MYDebugItemModel *> *)moduleItems {
    MYDebugSectionModel *sectionModel = [[MYDebugSectionModel alloc] init];
    sectionModel.moduleName = moduleName;
    sectionModel.itemModels = moduleItems;
    [self.sectionModels addObject:sectionModel];
}

- (NSArray<MYDebugSectionModel *> *)models {
    return self.sectionModels.copy;
}

@end

