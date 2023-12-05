//
//  MYChatManager.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//

#import "MYChatManager.h"
#import <Reachability/Reachability.h>
#import <MYUtils/MYUtils.h>
#import "MYUserManager.h"
#import "MYSocketManager.h"
#import "MYMessageFactory.h"
#import "MYUser+MYConvert.h"

static int MAGIC_NUMBER = 891013;

NSString *const CHAT_CONNECT_SUCCESS = @"CHAT_CONNECT_SUCCESS";
NSString *const CHAT_CONNECT_FAILURE = @"CHAT_CONNECT_FAILURE";

@interface MYChatManager () <MYSocketManagerDelegate>

@property (nonatomic, strong) NSMutableArray<id<MYChatManagerDelegate>> *delegateArray;

@property (nonatomic, strong) NSTimer *heartbeatTimer;/**<  心跳机制 */
@property (nonatomic, strong) NSTimer *reconnectWaitTimer;/**<  重连等待时间 */
@property (nonatomic, assign) int retryCount;/**<  重试次数 */

@end

@implementation MYChatManager

- (void)dealloc {
    [TheSocket removeDelegate:self];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

static MYChatManager *__onetimeClass;
+ (instancetype)defaultChatManager {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[MYChatManager alloc] init];
    });
    return __onetimeClass;
}

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onReceiveLoginNotification)
                                                   name:LOGIN_SUCCESS_NOTIFICATION object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onReceiveLoginNotification)
                                                   name:AUTO_LOGIN_SUCCESS_NOTIFICATION object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onReceiveLogoutNotification)
                                                   name:LOGOUT_NOTIFICATION object:nil];
        _delegateArray = [NSMutableArray array];
        _retryCount = 3;
    }
    return self;
}

- (void)registerNotification {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(onReceiveNetworkStateChange)
                                               name:kReachabilityChangedNotification object:nil];
}

- (void)initChat {
    [TheSocket addDelegate:self];
    [self registerNotification];
}

- (void)addChatDelegate:(id<MYChatManagerDelegate>)delegate {
    if (![self.delegateArray containsObject:delegate]) {
        [self.delegateArray addObject:delegate];
    }
}

- (void)removeChatDelegate:(id<MYChatManagerDelegate>)delegate {
    if ([self.delegateArray containsObject:delegate]) {
        [self.delegateArray removeObject:delegate];
    }
}

- (void)resetRetryCount {
    _retryCount = 3;
}

#pragma mark - notification

- (void)onReceiveNetworkStateChange {
    [self resetRetryCount];
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
//        NSLog(@"有wifi");
        [self reconnectSocket];
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
//        NSLog(@"使用手机自带网络进行上网");
        [self reconnectSocket];
    } else { // 没有网络
//        NSLog(@"没有网络");
        [TheSocket disConnect];
    }
}

- (void)reconnectSocket {
    _retryCount--;
    [MYLog debug:@"reconnectSocket"];
    if (!TheSocket.isConnect) {
        [TheSocket connect];
    }
}

#pragma mark - MYSocketManagerDelegate

- (void)didConnectSuccess:(MYSocketManager *)manager {
    [self resetRetryCount];
    // 发送登录信息
    MYMessage *message = [MYMessageFactory messageWithMesssageType:MYMessageType_REQUEST_LOGIN];
    message.content = TheUserManager.user.token;
    [TheSocket sendMessage:message];
}

- (void)didConnectFailure:(MYSocketManager *)manager error:(NSError *)error {
    [self clearHeartbeat];
    [self resetRetryCount];
    [self reconnectSocket];
    if (!_retryCount) {
        [self clearWaitTimer];
        for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
            if ([delegate respondsToSelector:@selector(chatManagerIsDisConnect:)]) {
                [delegate chatManagerIsDisConnect:self];
            }
        }
    }
}

- (void)didWriteDataSuccess:(MYSocketManager *)manager tag:(long)tag {
    for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
        if ([delegate respondsToSelector:@selector(chatManager:sendMessageSuccessWithTag:)]) {
            [delegate chatManager:self sendMessageSuccessWithTag:tag];
        }
    }
}

- (void)didReceiveOnManager:(MYSocketManager *)manager message:(MYMessage *)message {
    [self clearHeartbeat];
    if (message.messageType == MYMessageType_REQUEST_LOGIN) {
        NSString *content = message.content;
        if (content.intValue == MAGIC_NUMBER) {
            //success
            [NSNotificationCenter.defaultCenter postNotificationName:CHAT_CONNECT_SUCCESS object:nil];
            [self sendContext:TheUserManager.user.token toUser:nil withMsgType:MYMessageType_REQUEST_OFFLINE_MSGS];
        } else {
            //TODO: wmy 重试机制
            NSLog(@"connect failure:%@",content);
            [NSNotificationCenter.defaultCenter postNotificationName:CHAT_CONNECT_FAILURE object:nil];
        }
    } else if (message.messageType == MYMessageType_REQUEST_OFFLINE_MSGS) {
//        [self clearHeartbeat];
    } else if (message.messageType == MYMessageType_REQUEST_HEART_BEAT) {
//        [self resetHeartbeat];
    } else if (message.messageType == MYMessageType_CHAT_MESSAGE) {
//        [self resetHeartbeat];
        for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
            if ([delegate respondsToSelector:@selector(chatManager:didReceiveMessage:fromUser:)]) {
                MYUser *user = [MYUser convertFromDBModel:[theChatUserManager chatPersonWithUserId:message.fromId]];
                //TODO: wmy 添加到聊天窗口中
                [delegate chatManager:self didReceiveMessage:message fromUser:user];
            }
        }
    }
}

- (void)sendContext:(NSString *)content toUser:(MYUser *)user withMsgType:(MYMessageType)msgType {
    MYMessage *message = [MYMessageFactory messageWithMesssageType:msgType];
    message.content = content;
    message.toId = user.userId;
    message.toEntity = MYMessageEntiteyType_USER;
    [TheSocket sendMessage:message];
}


#pragma mark - heart beat

- (void)clearHeartbeat {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendHeartbeat) object:nil];
    [_heartbeatTimer timeInterval];
    _heartbeatTimer = nil;
}

- (void)resetHeartbeat {
    [self clearHeartbeat];
    NSInteger stepTime = 5 * 60;
    // 每5分钟发一次数据
    _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:stepTime
                                              target:self
                                            selector:@selector(sendHeartbeat)
                                            userInfo:nil repeats:YES];
}

- (void)startWaitTimer {
    NSInteger waitTime = 2 * 60;
    _reconnectWaitTimer = [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(reconnectSocket) userInfo:nil repeats:YES];
}

- (void)clearWaitTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reconnectSocket) object:nil];
    [_reconnectWaitTimer timeInterval];
    _reconnectWaitTimer = nil;
}

- (void)sendHeartbeat {
    MYMessage *message = [MYMessageFactory messageWithMesssageType:MYMessageType_REQUEST_HEART_BEAT];
    [self sendContext:nil toUser:nil withMsgType:MYMessageType_REQUEST_HEART_BEAT];
}

#pragma mark - notification

- (void)onReceiveLogoutNotification {
    [TheSocket disConnect];
}

- (void)onReceiveLoginNotification {
    //1. 开启长连接
    [TheSocket disConnect];
    [TheSocket connect];
}


@end
