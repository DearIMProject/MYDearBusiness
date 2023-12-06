//
//  MYChatPersonDataSource.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//

#import "MYDataSource.h"
#import <MYNetwork/MYNetwork.h>
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYChatPersonDataSource : MYDataSource

- (void)addMessage:(nullable MYMessage *)message fromUser:(MYUser *)user;

@property (nonatomic, strong) MYInteractor *interactor;

@end

NS_ASSUME_NONNULL_END
