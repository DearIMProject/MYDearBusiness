//
//  MYUser+MYConvert.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/22.
//

#import "MYUser+MYConvert.h"

@implementation MYUser (MYConvert)

+ (instancetype)convertFromDBModel:(MYDBUser *)dbModel {
    MYUser *user = [[MYUser alloc] init];
    user.userId = dbModel.userId;
    user.username = dbModel.name;
    user.icon = dbModel.iconURL;
    user.email = dbModel.email;
    user.status = dbModel.status;
    return user;
}

@end

@implementation MYDBUser (MYConvert)

+ (instancetype)convertFromUser:(MYUser *)dbModel {
    MYDBUser *user = [[MYDBUser alloc] init];
    user.userId = dbModel.userId;
    user.name = dbModel.username;
    user.iconURL = dbModel.icon;
    user.email = dbModel.email;
    user.status = dbModel.status;
    return user;
}

@end
