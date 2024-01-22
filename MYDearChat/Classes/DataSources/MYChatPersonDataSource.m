//
//  MYChatPersonDataSource.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//

//TODO: wmy 本地创建一个数据库，用于存放通讯录好友

#import "MYChatPersonDataSource.h"
#import "MYChatPersonViewModel.h"
#import <MYDearBusiness/MYDearBusiness.h>
#import "MYUserManager.h"

@interface MYChatPersonDataSource ()

@property (nonatomic, strong) MYSectionModel *sectionModel;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,MYChatPersonViewModel *> *chatMap;
@property (nonatomic, strong) NSMutableArray<MYChatPersonViewModel *> *chatPersonVMs;

@end

@implementation MYChatPersonDataSource

- (void)dealloc {
    [self.interactor unregisterTarget:self forEventName:kClickAddressItemEventName];
}

- (instancetype)init {
    if(self = [super init]) {
        _sectionModel = [[MYSectionModel alloc] init];
        self.sectionModels = @[self.sectionModel];
        _chatMap = [NSMutableDictionary dictionary];
        _chatPersonVMs = [NSMutableArray array];
        self.sectionModel.viewModels = self.chatPersonVMs;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onReceiveSendMessageSuccess:) name:MESSAGE_SEND_SUCCESS_NOTIFICATION object:nil];
    }
    return self;
}

- (void)request {
    [self.chatPersonVMs removeAllObjects];
    long userId = TheUserManager.user.userId;
    NSArray<MYDBUser *> *chatPersons = [theDatabase getChatListWithUserId:userId];
    for (MYDBUser *chatPerson in chatPersons) {
        MYChatPersonViewModel *vm = [[MYChatPersonViewModel alloc] init];
        [vm convertFromDBModel:chatPerson];
        self.chatMap[@(vm.userId)] = vm;
        vm.msgContent = [theDatabase lastestContentWithUserId:vm.userId];
        vm.messageNumber = [theDatabase getNotReadNumberWithUserId:vm.userId];
        [self.chatPersonVMs addObject:vm];
    }
    
    if (self.successBlock) self.successBlock();
}

- (int)totalMsgCount {
    return [theDatabase getNotReadNumbers];
}

- (void)addMessage:(MYMessage *)message fromUser:(MYUser *)user {
    long long mUserId = message.fromId;
    if (mUserId == TheUserManager.uid) {
        mUserId = message.toId;
    }
    MYChatPersonViewModel *vm = self.chatMap[@(mUserId)];
    if (!vm) {
        vm = [[MYChatPersonViewModel alloc] init];
        MYDBUser *dbUser = [theDatabase getChatPersonWithUserId:mUserId];
        [vm convertFromDBModel:dbUser];
        vm.msgContent = message.content;
        [self.chatPersonVMs insertObject:vm atIndex:0];
        self.chatMap[@(mUserId)] = vm;
    }
    if (message) {
        // 添加message到数据库中
        MYDataMessage *dbMessage = [MYMessage convertFromMessage:message];
        // 这里添加一个消息，要通过消息管理中心来添加
        vm.messageNumber = [theDatabase getNotReadNumberWithUserId:mUserId];
    }
    if (self.successBlock) self.successBlock();
}

- (void)setInteractor:(MYInteractor *)interactor {
    [super setInteractor:interactor];
    [interactor registerTarget:self action:@selector(onReceiveAddChatPerson:) forEventName:kClickAddressItemEventName];
}

- (void)onReceiveSendMessageSuccess:(NSNotification *)notification {
    MYDataMessage *message = notification.userInfo[@"message"];
    MYChatPersonViewModel *vm = self.chatMap[@(message.toId)];
    vm.msgContent = message.content;
    if (self.successBlock) self.successBlock();
}

- (void)onReceiveAddChatPerson:(MYUser *)user {
    MYChatPersonViewModel *vm = self.chatMap[@(user.userId)];
    if (!vm) {
        MYDBUser *dbUser = [MYDBUser convertFromUser:user];
        [theDatabase setUserInChat:dbUser];
    }
    
    [self addMessage:nil fromUser:user];
}

@end
