//
//  MYChatMessageViewModel.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYChatMessageViewModel.h"
#import "MYUserManager.h"
#import <MYClientDatabase/MYClientDatabase.h>
#import <MYDearBusiness/MYDearBusiness.h>

NSString * const kCanRecordMesssageTagEventName = @"kCanRecordMesssageTagEventName";

@interface MYChatMessageViewModel ()

@property(nonatomic, weak) MYDBUser *dataChatPerson;
@property(nonatomic, assign) long fromId;/**<  消息发送方 */
@property (nonatomic, assign) NSTimeInterval tag;
@property (nonatomic, strong) NSString *iconURL;

@end

@implementation MYChatMessageViewModel

- (Class)itemViewClass {
    if (self.isBelongMe) {
        return NSClassFromString(@"MYChatMeMessageItemView");
    }
    return NSClassFromString(@"MYChatAnotherMessageItemView");
}

- (void)convertWithDataModel:(MYDataMessage *)dbModel {
    MYMessage *message = [MYMessage convertFromMessage:dbModel];
    [self convertWithMessage:message];
}

- (void)convertWithMessage:(MYMessage *)message {
    self.model = message;
    self.fromId = message.fromId;
    self.tag = message.timestamp;

}


- (MYMessageStatus)sendSuccessStatus {
    return self.model.sendStatus;
}

- (NSString *)content {
    return self.model.content;
}

- (void)setMsgSendSuccessWithUserId:(long long)userId {
    // 调用dataclient进行
    [MYLog debug:@"收到消息推送成功消息"];
    BOOL isSuccess = [theDatabase sendSuccessWithTimer:self.model.timestamp messageId:self.model.msgId withUserId:userId belongToUserId:TheUserManager.uid];
    self.model.sendStatus = MYMessageStatus_Success;
}

- (void)setSendFailure {
    self.model.sendStatus = MYMessageStatus_Failure;
    //TODO: wmy
    [theDatabase messageSendFailureInMessage:[MYMessage convertFromMessage:self.model]];
}

- (NSString *)iconURL {
    //TODO: wmy 这里如果iconURL为空，直接获取数据库中的url；
    if (!_iconURL) {
        if ([self isBelongMe]) {
            _iconURL = [theDatabase getChatPersonWithUserId:TheUserManager.uid].iconURL;
        } else {
            _iconURL = [theDatabase getChatPersonWithUserId:self.model.fromId].iconURL;
        }
    }
    return _iconURL;
}

- (BOOL)isBelongMe {
    if (self.fromId == TheUserManager.user.userId) {
        return YES;
    }
    return NO;
}

- (MYDBUser *)dataChatPerson {
    if (!_dataChatPerson) {
        _dataChatPerson =  [theChatUserManager chatPersonWithUserId:self.model.fromId];
    }
    return _dataChatPerson;
}

@end
