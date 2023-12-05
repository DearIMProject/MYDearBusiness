//
//  MYRequest.m
//  MYBookkeeping
//
//  Created by APPLE on 2022/1/28.
//

#import "MYRequest.h"
#import <MYDearUser/MYDearUser.h>
#import <MYUtils/MYUtils.h>
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
    [MYLog debug:@"[request]----------------↓ request ↓-----------------"];
    [MYLog debug:@"api:%@",apiName];
    [MYLog debug:@"version:%@",version];
    [MYLog debug:@"params:%@",params];
    [super requestApiName:apiName version:version
                    param:params success:^(NSDictionary *result) {
        [MYLog debug:@"result:%@",result];
        [MYLog debug:@"[request]----------------↑ success ↑-----------------"];
        if (success) success(result);
    }
                  failure:^(NSError * _Nonnull error) {
        if (error.code == ERROR_CODE_TOKEN_EXPIRE) {
            MYUserManager.shared.user = nil;
            [MYApplicationManager.shared refreshRootViewController];
            [NSNotificationCenter.defaultCenter postNotificationName:LOGOUT_NOTIFICATION object:nil];
        }
        [MYLog debug:@"[request]----------------↑ failure ↑-----------------"];
        if (failure) failure(error);
    }];
}

- (NSDictionary *)baseParam {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = MYUserManager.shared.user.token;
    return dict;
}

@end
