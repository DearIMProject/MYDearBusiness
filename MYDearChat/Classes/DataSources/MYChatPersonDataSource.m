//
//  MYChatPersonDataSource.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//

//TODO: wmy 本地创建一个数据库，用于存放通讯录好友

#import "MYChatPersonDataSource.h"
#import "MYChatPersonViewModel.h"
#import <MYClientDatabase/MYClientDatabase.h>
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
    long userId = TheUserManager.user.userId;
    NSArray<MYDBUser *> *chatPersons = [theDatabase getAllChatPersonWithUserId:userId];
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
    vm.messageNumber++;
    if (self.successBlock) self.successBlock();
}

@end
