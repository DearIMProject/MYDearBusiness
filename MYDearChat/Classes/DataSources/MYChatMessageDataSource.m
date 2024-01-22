//
//  MYChatMessageDataSource.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYChatMessageDataSource.h"
#import "MYChatMessageViewModel.h"
#import "MYMessage+MYConvert.h"
#import <MYDearBusiness/MYDearBusiness.h>
#import <MYClientDatabase/MYClientDatabase.h>

#import "MYChatPersonViewModel.h"

@interface MYChatMessageDataSource () <MYChatManagerDelegate>

@property (nonatomic, strong) MYSectionModel *sectionModel;
@property (nonatomic, strong) NSMutableArray<MYChatMessageViewModel *> *vms;

@end

@implementation MYChatMessageDataSource

- (void)dealloc {
    [theChatManager removeChatDelegate:self];
    [self.interactor unregisterTarget:self forEventName:kMessageNeedRetryEvent];
    [self.interactor unregisterTarget:self forEventName:kMessageNeedSendEvent];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionModel = [[MYSectionModel alloc] init];
        self.sectionModels = @[self.sectionModel];
        _vms = [NSMutableArray array];
        self.sectionModel.viewModels = self.vms;
        [theChatManager addChatDelegate:self];
    }
    return self;
}

- (void)setInteractor:(MYInteractor *)interactor {
    [super setInteractor: interactor];
    [self.interactor registerTarget:self action:@selector(onReceiveRetry:) forEventName:kMessageNeedRetryEvent];
    [self.interactor registerTarget:self action:@selector(onReceiveResend:) forEventName:kMessageNeedSendEvent];
}

- (void)request {
    NSArray<MYDataMessage *> *dataMessages = [theDatabase getChatMessageWithPerson:self.viewModel.userId];
    for (MYDataMessage *dataMessage in dataMessages) {
        MYChatMessageViewModel *vm = [[MYChatMessageViewModel alloc] init];
        [vm convertWithDataModel:dataMessage];
        [self.vms addObject:vm];
    }
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)onReceiveResend:(MYChatMessageViewModel *)viewModel {
    [self sendMessageContent:viewModel.content];
}


- (void)sendMessageContent:(NSString *)content {
    MYMessage *message = [theChatManager sendContext:content
                                              toUser:self.viewModel.model
                                         withMsgType:MYMessageType_TEXT];
    [self addChatMessage:message withUser:self.viewModel.model];
}

- (void)onReceiveRetry:(MYChatMessageViewModel *)viewModel {
    [viewModel setSendFailure];
    //TODO: wmy
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)addChatMessage:(MYMessage *)message withUser:(MYUser *)user {
    // message添加到数据库中
    MYDataMessage *dbMessage = [MYMessage convertFromMessage:message];
    [theDatabase addChatMessage:dbMessage withUserId:user.userId];
    // ui交互
    MYChatMessageViewModel *vm = [[MYChatMessageViewModel alloc] init];
    [vm convertWithDataModel:dbMessage];
    [self.vms addObject:vm];
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)successMessageWithTag:(NSTimeInterval)tag messageId:(long long)messageId {
    NSEnumerator *reverseEnumerator = [self.vms reverseObjectEnumerator];
    MYChatMessageViewModel *vm;
    while (vm = [reverseEnumerator nextObject]) {
        if (vm.tag == tag) {
            vm.model.msgId = messageId;
            [vm setMsgSendSuccessWithUserId:self.viewModel.userId];
            //TODO: wmy 调用数据库代码
            break;
        }
    }
    if (self.successBlock) {
        self.successBlock();
    }
}

- (void)chatManager:(MYChatManager *)manager setReadedMessage:(NSTimeInterval)timestamp {
    [self.interactor sendEventName:kReadedMesssageTagEventName withObjects:@(timestamp)];
}

@end 
