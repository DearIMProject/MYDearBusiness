//
//  MYChatMessageDataSource.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYDataSource.h"
#import "MYMessage.h"
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@class MYChatPersonViewModel;

@interface MYChatMessageDataSource : MYDataSource

@property (nonatomic, strong) MYChatPersonViewModel *viewModel;

@property (nonatomic, strong) MYInteractor *interactor; 

- (void)addChatMessage:(MYMessage *)message byUser:(MYUser *)user;

- (void)successMessageWithTag:(NSTimeInterval)tag;

- (void)sendMessageContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
