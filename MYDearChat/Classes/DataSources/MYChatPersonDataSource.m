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

- (instancetype)init {
    if(self = [super init]) {
        _sectionModel = [[MYSectionModel alloc] init];
        self.sectionModels = @[self.sectionModel];
        _chatMap = [NSMutableDictionary dictionary];
        _chatPersonVMs = [NSMutableArray array];
        self.sectionModel.viewModels = self.chatPersonVMs;
    }
    return self;
}

- (void)request {
    [self.chatPersonVMs removeAllObjects];
    long userId = TheUserManager.user.userId;
    NSArray<MYDBUser *> *chatPersons = [theDatabase getChatListWithUserId:userId];
    for (MYDBUser *chatPerson in chatPersons) {
        MYChatPersonViewModel *vm = [[MYChatPersonViewModel alloc] init];
        self.chatMap[@(vm.userId)] = vm;
        [vm convertFromDBModel:chatPerson];
        [self.chatPersonVMs addObject:vm];
    }

    if (self.successBlock) self.successBlock();
}

- (void)addMessage:(MYMessage *)message fromUser:(MYUser *)user {
    MYChatPersonViewModel *vm = self.chatMap[@(user.userId)];
    if (!vm) {
        vm = [[MYChatPersonViewModel alloc] init];
        [vm converFromUser:user];
        vm.msgContent = message.content;
        [self.chatPersonVMs insertObject:vm atIndex:0];
        self.chatMap[@(vm.userId)] = vm;
    }
    if (message) {
        // 添加message到数据库中
        MYDataMessage *dbMessage = [MYMessage convertFromMessage:message];
        [theDatabase addChatMessage:dbMessage fromUserId:user.userId belongToUserId:TheUserManager.uid];
        vm.messageNumber++;
    }
    if (self.successBlock) self.successBlock();
}

- (void)setInteractor:(MYInteractor *)interactor {
    _interactor = interactor;
    [interactor registerTarget:self action:@selector(onReceiveAddChatPerson:) forEventName:kClickAddressItemEventName];
}

- (void)onReceiveAddChatPerson:(MYUser *)user {
    MYChatPersonViewModel *vm = self.chatMap[@(user.userId)];
    if (!vm) {
        MYDBUser *dbUser = [MYDBUser convertFromUser:user];
        [theDatabase setUserInChat:dbUser withOwnerUserId:TheUserManager.uid];
    }
    
    [self addMessage:nil fromUser:user];
}

@end
