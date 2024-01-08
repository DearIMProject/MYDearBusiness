//
//  MYDearDebug.m
//  Pods
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDearDebug.h"
#import "MYDebugView.h"
#import "MYDebugSectionModel.h"

@interface MYDearDebug ()

@property (nonatomic, strong) MYDebugView *debugView;
@property (nonatomic, assign) BOOL isShowDebug;
@property (nonatomic, strong) NSMutableArray<MYDebugSectionModel *> *sectionModels;


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
    _debugView.layer.zPosition = 100;
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

