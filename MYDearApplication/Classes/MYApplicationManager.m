//
//  MYApplicationManager.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/2.
//

#import "MYApplicationManager.h"
#import <MYMVVM/MYMVVM.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <MYDearLogin/MYLoginViewController.h>
#import <MYDearUser/MYDearUser.h>

#import <MYNetwork/MYNetwork.h>
#import <MYDearBusiness/ViewController.h>
#import <MYDearBusiness/MYChatManager.h>

#import <MYDearHome/MYHomeTabbarViewController.h>

@interface MYApplicationManager ()

@property(nonatomic, strong) MYNavigationViewController *naviController;

@end

@implementation MYApplicationManager

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [theChatManager initChat];
    }
    return self;
}

- (void)refreshRootViewController {
    self.mainWindow.rootViewController = self.rootViewController;
    [self.mainWindow makeKeyWindow];
}

- (UIViewController *)rootViewController {
//    #if DEBUG
//        ViewController *tabbar = [[ViewController alloc] init];
//        UINavigationController *testnavi = [[UINavigationController alloc] initWithRootViewController:tabbar];
//        return testnavi;
//    #endif
    if ([MYUserManager.shared isLogin] && !MYUserManager.shared.isExpireTime) {
        MYHomeTabbarViewController *tabBar = [[MYHomeTabbarViewController alloc] init];
        MYNavigationViewController *navi = [[MYNavigationViewController alloc] initWithRootViewController:tabBar];
        self.naviController = navi;
        return navi;
    }
    
    MYNavigationViewController *navi =
            [[MYNavigationViewController alloc] initWithRootViewController:MYLoginViewController.new];
    self.naviController = navi;
    return navi;
}

- (UIViewController *)topViewController {
    return self.naviController.topViewController;
}

#pragma mark - appdelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //用户自动登录
    @weakify(self);
    [TheUserManager checkAutoLoginWithSuccess:^{
//        [MBProgressHUD showSuccess:@"login_success".local toView:self.mainWindow];
    }                                 failure:^(NSError *_Nonnull error) {
        @strongify(self);
//        [MBProgressHUD showError:error.description toView:self.mainWindow];
        self.mainWindow.rootViewController = self.rootViewController;
        [self.mainWindow makeKeyAndVisible];
    }];

    NSString *apiAddress = @"172.16.92.113";
    theNetworkManager.host = apiAddress;
    TheSocket.host = apiAddress;
    return YES;
}

@end