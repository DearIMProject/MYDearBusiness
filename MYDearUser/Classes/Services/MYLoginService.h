//
//  MYLoginService.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(void);
typedef void(^FailureBlock)(NSError *error);

@interface MYLoginService : NSObject

/// 登录
/// - Parameters:
///   - email: 邮箱
///   - password: 密码
///   - success: 成功回调
///   - failure: 失败回调
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/// 自动登录
/// - Parameters:
///   - success: 成功回调
///   - failure: 失败回调
- (void)autoLoginWithSuccess:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/// 登出
/// - Parameters:
///   - success: 成功回调
///   - failure: 失败回调
- (void)logoutWithSuccess:(SuccessBlock)success
                  failure:(FailureBlock)failure;


/// 注册
/// - Parameters:
///   - email: 邮箱
///   - password: 密码
///   - confirmPassword: 密码确认
///   - success: 成功回调
///   - failure: 失败回调
- (void)registWithEmail:(NSString *)email
               password:(NSString *)password
        confirmPassword:(NSString *)confirmPassword
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;


/// 验证码
/// - Parameters:
///   - code: 验证码
///   - email: 邮箱
///   - success: 成功回调
///   - failure: 失败回调
- (void)checkCode:(NSString *)code
            email:(NSString *)email
          success:(SuccessBlock)success
          failure:(FailureBlock)failure;


/// 发送验证码
/// - Parameters:
///   - email: 邮箱
///   - success: 成功回调
///   - failure: 失败回调
- (void)sendCheckCode:(NSString *)email
              success:(SuccessBlock)success
              failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
