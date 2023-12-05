//
//  MYAddressService.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressService.h"
#import <YYModel/YYModel.h>
#import <MYDearBusiness/MYDearBusiness.h>
#import "MYRequest.h"
#import <MYClientDatabase/MYClientDatabase.h>


@interface MYAddressService ()

@property (nonatomic, strong) MYRequest *request;

@end

@implementation MYAddressService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _request = [[MYRequest alloc] init];
    }
    return self;
}

- (void)getAllAddressListWithSuccess:(void(^)(NSArray<MYUser *> * _Nonnull users))success
                             failure:(void(^)(NSError * _Nonnull error))failure {
    //TODO: wmy 先获取数据库的列表，再返回请求的数据
    NSArray<MYDBUser *> *dbUsers = [theDatabase getAllChatPersonWithUserId:TheUserManager.uid];
    NSMutableArray<MYUser *> *users = [NSMutableArray array];
    for (MYDBUser *dbUser in dbUsers) {
        MYUser *user = [MYUser convertFromDBModel:dbUser];
        [users addObject:user];
    }
    if (success) success(users);
    
    // 获取网络数据
    //TODO: wmy 1. 若本地什么都没有，获取所有的通讯录
    // 2. 若本地有数据，可以询问云端客户端的增量数据
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self.request requestApiName:@"/addressbook/all" version:@""
                           param:param success:^(NSDictionary * _Nonnull result) {
            //TODO: wmy
        NSArray<MYUser *> *users = [NSArray yy_modelArrayWithClass:MYUser.class json:result[@"list"]];
        
        if (success) {
            success(users);
        }
        [self saveUsers:users];
        } failure:failure];
}


- (void)saveUsers:(NSArray<MYUser *> *)users {
    NSMutableArray<MYDBUser *> *dbUsers = [NSMutableArray array];
    for (MYUser *user in users) {
        MYDBUser *dbUser = [MYDBUser convertFromUser:user];
        [dbUsers addObject:dbUser];
    }
    [theDatabase updateAllUser:dbUsers fromUid:TheUserManager.uid];
}

@end
