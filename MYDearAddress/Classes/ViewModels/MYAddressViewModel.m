//
//  MYAddressViewModel.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressViewModel.h"
#import <MYClientDatabase/MYClientDatabase.h>
#import "MYUser+MYConvert.h"

@implementation MYAddressViewModel

@dynamic model;

- (Class)itemViewClass {
    return NSClassFromString(@"MYAddressListItemView");
}

- (CGSize)itemSize {
    return CGSizeMake(0, 56);
}
- (void)convertFromDBModel:(MYDBUser *)chatPerson {
    //TODO: wmy 将chatPerson 转为user
    MYUser *user = [MYUser convertFromDBModel:chatPerson];
    [self converFromUser:user];
}

- (void)addChatPerson {
    // 添加到数据库中
    MYDBUser *dbUser = [MYDBUser convertFromUser:self.model];
    [theDatabase setUserInChat:dbUser];
}

- (void)converFromUser:(MYUser *)user {
    self.model = user;
    self.name = user.username;
    self.iconURL = user.icon;
    self.userId = user.userId;
}

@end
