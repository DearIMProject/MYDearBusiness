//
//  MYApplicationNotificationManager.m
//  MYDearApplication
//
//  Created by APPLE on 2023/12/1.
//

#import "MYApplicationNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <MYClientDatabase/MYClientDatabase.h>
#import <MYUtils/MYUtils.h>
#import "MYChatManager.h"

@interface MYApplicationNotificationManager () <MYChatManagerDelegate, UNUserNotificationCenterDelegate>

@end

@implementation MYApplicationNotificationManager

- (void)dealloc {
    [theChatManager removeChatDelegate:self];
}

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [theChatManager addChatDelegate:self];
    }
    return self;
}

- (void)setup {
    [self registRemoteNotification];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
}

/// 注册通知
- (void)registRemoteNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    __weak typeof(self) weakSelf = self;
    UNAuthorizationOptions notificationType = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound ;
    [center requestAuthorizationWithOptions:notificationType
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
        }
    }];
    
}

#pragma mark - MYChatManagerDelegate

- (void)chatManager:(MYChatManager *)manager didReceiveMessage:(MYMessage *)message fromUser:(MYUser *)user {
    // 生成一个本地消息
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //TODO: wmy 这里搜索一下 之后群需要再检索一下
    MYDBUser *dbuser = [theDatabase getChatPersonWithUserId:message.fromId];
    content.title = dbuser.name;
//    content.subtitle = message.content;
    //TODO: wmy 设置通知铃声
//    content.sound = [UNNotificationSound soundNamed:fileName];
    content.badge = @(1);
//    content.interruptionLevel = UNNotificationInterruptionLevelTimeSensitive;//会使手机亮屏且会播放声音；可能会在免打扰模式（焦点模式）下展示
    // @"{\"aps\":{\"interruption-level\":\"time-sensitive\"}}";
    // @"{\"aps\":{\"interruption-level\":\"active\"}}";
    content.body = message.content;// 本地推送一定要有内容，即body不能为空。
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    // 添加通知的标识符，可以用于移除，更新等操作
    NSString *identifier = [NSString stringWithFormat:@"localPushId%ld", message.timestamp];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        [MYLog debug:error.domain];
    }];
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    //TODO: wmy 用户点击本地通知时调用
    completionHandler();
}


@end
