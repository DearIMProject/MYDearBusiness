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

#import <UserNotifications/UserNotifications.h>
#import "MYApplicationNotificationManager.h"
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
        [self setupLogger];
    }
    return self;
}

- (void)setupLogger {
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelAll];
    // 配置文件日志输出
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 每24小时创建一个新文件
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 保留最近7天的日志文件
    [DDLog addLogger:fileLogger];
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
    navi.backColor = TheSkin.themeColor;
    self.naviController = navi;
    return navi;
}

- (UIViewController *)topViewController {
    return self.naviController.topViewController;
}

#pragma mark - appdelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MYApplicationNotificationManager.shared setup];
    NSString *apiAddress = @"172.16.92.96";
    theNetworkManager.host = apiAddress;
    TheSocket.host = apiAddress;
    
    //用户自动登录
    if (TheUserManager.user.token) {
        @weakify(self);
        [TheUserManager checkAutoLoginWithSuccess:^{
            //        [MBProgressHUD showSuccess:@"login_success".local toView:self.mainWindow];
        }                                 failure:^(NSError *_Nonnull error) {
            @strongify(self);
            [self refreshRootViewController];
        }];
    }
    return YES;
}

@end
