//
//  MYChatMessageDataSource.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYDataSource.h"
#import "MYMessage.h"
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@class MYChatPersonViewModel;

@interface MYChatMessageDataSource : MYDataSource

@property (nonatomic, strong) MYChatPersonViewModel *viewModel;

@property (nonatomic, strong) MYInteractor *interactor; 

/// 添加一个消息
/// - Parameters:
///   - message: 消息
///   - user: 当前用户和谁聊天
- (void)addChatMessage:(MYMessage *)message withUser:(MYUser *)user;

- (void)successMessageWithTag:(NSTimeInterval)tag messageId:(long long)messageId;

- (void)sendMessageContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
