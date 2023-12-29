//
//  MYChatMessageViewModel.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import <MYMVVM/MYMVVM.h>
#import <MYClientDatabase/MYClientDatabase.h>
#import <MYNetwork/MYNetwork.h>

NS_ASSUME_NONNULL_BEGIN

#define kMessageNeedRetryEvent @"kMessageNeedRetryEvent"// 消息重试
#define kMessageNeedSendEvent @"kMessageNeedSendEvent"// 消息重发

@interface MYChatMessageViewModel : MYViewModel

@property(nonatomic, strong, readonly) NSString *content;/**<  消息内容 */
@property (nonatomic, assign, readonly) NSTimeInterval tag;

@property (nonatomic, strong) MYMessage *model;

@property (nonatomic, assign, readonly) MYMessageStatus sendSuccessStatus;
/**
 * 用户图片
 */
- (NSString *)iconURL;

- (void)convertWithDataModel:(MYDataMessage *)dbModel;

- (void)convertWithMessage:(MYMessage *)message;

- (BOOL)isBelongMe;

- (void)setMsgSendSuccess;

@end

NS_ASSUME_NONNULL_END
