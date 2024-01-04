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


@interface MYChatMessageViewModel ()

@property(nonatomic, weak) MYDBUser *dataChatPerson;
@property(nonatomic, assign) long fromId;/**<  消息发送方 */
@property (nonatomic, assign) NSTimeInterval tag;

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
    //TODO: wmy 通过通讯录获取icon
    self.dataChatPerson = [theChatUserManager chatPersonWithUserId:message.fromId];
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

- (NSString *)iconURL {
    //TODO: wmy 这里如果iconURL为空，直接获取数据库中的url；
    if ([self isBelongMe]) {
        return [theDatabase getChatPersonWithUserId:TheUserManager.uid].iconURL;
    } else {
        return [theDatabase getChatPersonWithUserId:self.dataChatPerson.userId].iconURL;
    }
}

- (BOOL)isBelongMe {
    if (self.fromId == TheUserManager.user.userId) {
        return YES;
    }
    return NO;
}

@end
