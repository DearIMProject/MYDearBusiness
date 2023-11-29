//
//  MYRequest.m
//  MYBookkeeping
//
//  Created by APPLE on 2022/1/28.
//

#import "MYRequest.h"
#import <MYDearUser/MYDearUser.h>
#import "MYApplicationManager.h"

typedef enum : NSUInteger {
    ERROR_CODE_TOKEN_EXPIRE = 1,
} ERROR_CODE;


@implementation MYRequest

- (void)requestApiName:(NSString *)apiName
               version:(NSString *)version
                 param:(NSDictionary *)param
               success:(void (^)(NSDictionary *result))success
               failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = param.mutableCopy;
    [params setValuesForKeysWithDictionary:self.baseParam];
    [super requestApiName:apiName version:version
                    param:param success:success
                  failure:^(NSError * _Nonnull error) {
        if (error.code == ERROR_CODE_TOKEN_EXPIRE) {
            MYUserManager.shared.user = nil;
            [MYApplicationManager.shared refreshRootViewController];
        }
        if (failure) failure(error);
    }];
}

- (NSDictionary *)baseParam {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = MYUserManager.shared.user.token;
    return dict;
}

@end
