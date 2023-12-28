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
@property (nonatomic, assign) BOOL isRetry;/**<  是否在重试中 */

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
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onReceiveBackgroundNotification)
                                                   name:UIApplicationDidEnterBackgroundNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onReceiveForgroundNotifiation)
                                                   name:UISceneWillEnterForegroundNotification object:nil];
        
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

- (void)onReceiveLogoutNotification {
    [MYLog debug:@"☎️[MYChatManager]收到退出登录消息，断连"];
    [TheSocket disConnect];
}

- (void)onReceiveLoginNotification {
    //1. 开启长连接
    [self connectSocket];
    [MYLog debug:@"☎️[MYChatManager]收到登录的消息，开启长连接"];
}

- (void)connectSocket {
    if (!TheSocket.isConnect) {
        [TheSocket disConnect];
        [TheSocket connect];
    }
}

- (void)onReceiveForgroundNotifiation {
    [self connectSocket];
    
    [MYLog debug:@"☎️[MYChatManager]收到切换到前台的消息，开启长连接"];
}

- (void)onReceiveBackgroundNotification {
    [MYLog debug:@"☎️[MYChatManager]收到进入后台的消息，断连"];
    [TheSocket disConnect];
}

- (void)onReceiveNetworkStateChange {
    [MYLog debug:@"☎️[MYChatManager]网络状态发生变化了"];
    if (self.isRetry) {
        return;
    }
    [self resetRetryCount];
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        [MYLog debug:@"☎️[MYChatManager]当前网络状态为wifi"];
        [self reconnectSocket];
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        [MYLog debug:@"☎️[MYChatManager]当前网络状态为手机自带网络"];
        [self reconnectSocket];
    } else { // 没有网络
        [MYLog debug:@"☎️[MYChatManager]当前木有网络"];
        [TheSocket disConnect];
    }
}

- (void)reconnectSocket {
    _retryCount--;
    [MYLog debug:@"☎️[MYChatManager]尝试重新连接socket"];
    if (!TheSocket.isConnect && self.isRetry) {
        [MYLog debug:@"☎️[MYChatManager]正在重连reconnectSocket"];
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
    if (TheUserManager.user.token && !self.isRetry) {
        self.isRetry = YES;
        [self resetRetryCount];
        [self reconnectSocket];
        [self resetWaitTimer];
        if (_retryCount < 0) {
            self.isRetry = NO;
            [self clearWaitTimer];
            for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
                if ([delegate respondsToSelector:@selector(chatManagerIsDisConnect:)]) {
                    [delegate chatManagerIsDisConnect:self];
                }
            }
        }
    }
}

- (void)didWriteDataSuccess:(MYSocketManager *)manager tag:(long)tag {
    //TODO: wmy ?
    for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
        if ([delegate respondsToSelector:@selector(chatManager:sendMessageSuccessWithTag:)]) {
            [delegate chatManager:self sendMessageSuccessWithTag:tag];
        }
    }
}

- (void)didReceiveOnManager:(MYSocketManager *)manager message:(MYMessage *)message {
    [self resetHeartbeat];
    if (message.messageType == MYMessageType_REQUEST_LOGIN) {
        NSString *content = message.content;
        if (content.intValue == MAGIC_NUMBER) {
            //success
            [NSNotificationCenter.defaultCenter postNotificationName:CHAT_CONNECT_SUCCESS object:nil];
            [self sendContext:TheUserManager.user.token toUser:nil withMsgType:MYMessageType_REQUEST_OFFLINE_MSGS];
            for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
                if ([delegate respondsToSelector:@selector(chatManagerIsConnectSuccess:)]) {
                    [delegate chatManagerIsConnectSuccess:self];
                }
            }
        } else {
            //TODO: wmy 重试机制
            NSLog(@"☎️[MYChatManager]connect failure:%@",content);
            [NSNotificationCenter.defaultCenter postNotificationName:CHAT_CONNECT_FAILURE object:nil];
        }
    } else if (message.messageType == MYMessageType_SEND_SUCCESS_MESSAGE) {
        NSTimeInterval tag = message.content.doubleValue;
        for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
            if ([delegate respondsToSelector:@selector(chatManager:sendMessageSuccessWithTag:)]) {
                [delegate chatManager:self sendMessageSuccessWithTag:tag];
            }
        }
    } else if (message.messageType == MYMessageType_REQUEST_OFFLINE_MSGS) {
        ;;
    } else if (message.messageType == MYMessageType_REQUEST_HEART_BEAT) {
        ;;
    } else if (message.messageType == MYMessageType_CHAT_MESSAGE) {
        for (id<MYChatManagerDelegate> delegate in self.delegateArray) {
            if ([delegate respondsToSelector:@selector(chatManager:didReceiveMessage:fromUser:)]) {
                MYUser *user = [MYUser convertFromDBModel:[theChatUserManager chatPersonWithUserId:message.fromId]];
                [delegate chatManager:self didReceiveMessage:message fromUser:user];
            }
        }
    }
}

- (MYMessage *)sendContext:(NSString *)content toUser:(MYUser *)user withMsgType:(MYMessageType)msgType {
    MYMessage *message = [MYMessageFactory messageWithMesssageType:msgType];
    message.content = content;
    message.toId = user.userId;
    message.toEntity = MYMessageEntiteyType_USER;
    [TheSocket sendMessage:message];
    return message;
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

- (void)resetWaitTimer {
    [self clearWaitTimer];
    [self startWaitTimer];
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



@end
