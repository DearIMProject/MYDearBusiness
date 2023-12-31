//
//  MYLoginService.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/2.
//

#import "MYLoginService.h"
#import <YYModel/YYModel.h>
#import <MYUtils/MYUtils.h>
#import "MYUserManager.h"
#import "MYRequest.h"



@interface MYLoginService ()

@property (nonatomic, strong) MYRequest *request;

@end

@implementation MYLoginService

- (instancetype)init {
    if (self = [super init]) {
        _request = [[MYRequest alloc] init];
        
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccessBlock)success
               failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = email;
    // MD5Utils
    param[@"password"] = password;
    [self.request requestApiName:@"/user/login"
                         version:@""
                           param:param
                         success:^(NSDictionary * _Nonnull result) {
        MYUser *user = [MYUser yy_modelWithJSON:result[@"user"]];
        TheUserManager.user = user;
        [NSNotificationCenter.defaultCenter postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
        if (success) {
            success();
        }
        } failure:failure];
}

- (void)autoLoginWithSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = TheUserManager.user.token;
    [self.request requestApiName:@"/user/autologin" version:@""
                           param:param
                         success:^(NSDictionary * _Nonnull result) {
        TheUserManager.user = [MYUser yy_modelWithJSON:result[@"user"]];
        [NSNotificationCenter.defaultCenter postNotificationName:AUTO_LOGIN_SUCCESS_NOTIFICATION object:nil];
        if (success) {
            success();
        }
        } failure:failure];
}

- (void)logoutWithSuccess:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = TheUserManager.user.token;
    [self.request requestApiName:@"/user/logout" version:@""
                           param:param
                         success:^(NSDictionary * _Nonnull result) {
        TheUserManager.user = nil;
        [NSNotificationCenter.defaultCenter postNotificationName:LOGOUT_NOTIFICATION object:nil];
        if (success) {
            success();
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        TheUserManager.user = nil;
        [NSNotificationCenter.defaultCenter postNotificationName:LOGOUT_NOTIFICATION object:nil];
    }];
}

- (void)registWithEmail:(NSString *)email password:(NSString *)password confirmPassword:(NSString *)confirmPassword success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = email;
    param[@"password"] = password;
    param[@"confirmPassword"] = confirmPassword;
    [self.request requestApiName:@"/user/register"
                         version:@""
                           param:param
                         success:^(NSDictionary * _Nonnull result) {
        if (success) success();
    } failure:failure];
}

- (void)checkCode:(NSString *)code
            email:(NSString *)email
          success:(SuccessBlock)success
          failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = email;
    param[@"code"] = code;
    [self.request requestApiName:@"/user/checkCode" version:@""
                           param:param success:^(NSDictionary * _Nonnull result) {
        if (success) success();
        } failure:failure];
}

- (void)sendCheckCode:(NSString *)email success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = email;
    [self.request requestApiName:@"/user/sendCheckCode" version:@""
                           param:param success:^(NSDictionary * _Nonnull result) {
        if (success) success();
        } failure:failure];
}

@end
