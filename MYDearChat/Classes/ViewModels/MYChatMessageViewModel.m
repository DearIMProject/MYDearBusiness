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
@property (nonatomic, assign) MYMessageStatus sendSuccessStatus;
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
    self.content = message.content;
    self.fromId = message.fromId;
    self.sendSuccessStatus = message.sendStatus;
    self.tag = message.timestamp;
    //TODO: wmy 通过通讯录获取icon
    self.dataChatPerson = [theChatUserManager chatPersonWithUserId:message.fromId];
}

- (void)setMsgSendSuccess {
    //TODO: wmy
    self.model.sendStatus = MYMessageStatus_Success;
}

- (NSString *)iconURL {
    return self.dataChatPerson.iconURL;
}

- (BOOL)isBelongMe {
    if (self.fromId == TheUserManager.user.userId) {
        return YES;
    }
    return NO;
}

@end
