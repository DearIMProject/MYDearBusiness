//
//  MYChatManager.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//  聊天相关链接业务
// 1，登录后监听登录信息，发送登录请求
// 2. 登录成功后向上发送通知
// 3. 维护一个待发送的队列。发送消息
// 4. 队列需要本地记录，下次启动登录成功后进行消息的自动发送
// 5.

#import <Foundation/Foundation.h>
#import <MYDearUser/MYDearUser.h>
#import "MYMessageEnum.h"
#import "MYMessage.h"

NS_ASSUME_NONNULL_BEGIN

#define theChatManager MYChatManager.defaultChatManager

FOUNDATION_EXPORT NSString *const CHAT_CONNECT_SUCCESS;
FOUNDATION_EXPORT NSString *const CHAT_CONNECT_FAILURE;

@class MYChatManager;


@protocol MYChatManagerDelegate <NSObject>

@optional;

/// 收到message消息
/// - Parameters:
///   - manager: manager
///   - message: 消息实例
///   - user: 来自用户的消息
- (void)chatManager:(MYChatManager *)manager didReceiveMessage:(MYMessage *)message fromUser:(MYUser *)user;

/// 消息发送成功
/// - Parameters:
///   - manager: manager
///   - tag: 消息tag 事实上为timestamp
- (void)chatManager:(MYChatManager *)manager sendMessageSuccessWithTag:(long)tag;

/// 收到离线消息
/// - Parameters:
///   - manager: manager
///   - messages: 离线消息list
- (void)chatManager:(MYChatManager *)manager onReceiveOfflineManager:(NSArray<MYMessage *> *)messages;

/// 和服务器长连接断连
/// - Parameter manager: manager
- (void)chatManagerIsDisConnect:(MYChatManager *)manager;

/// 和服务器连接成功
/// - Parameter manager: manager
- (void)chatManagerIsConnectSuccess:(MYChatManager *)manager;
@end


@interface MYChatManager : NSObject

+ (instancetype)defaultChatManager;

- (void)initChat;

- (MYMessage *)sendContext:(nullable NSString  *)content toUser:(nullable MYUser *)user withMsgType:(MYMessageType)msgType;

- (void)addChatDelegate:(id<MYChatManagerDelegate>)delegate;

- (void)removeChatDelegate:(id<MYChatManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
