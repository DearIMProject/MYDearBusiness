//
//  MYChatPersonViewModel.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/16.
//

#import "MYViewModel.h"
#import <MYClientDatabase/MYClientDatabase.h>
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYChatPersonViewModel : MYViewModel

@property (nonatomic, strong) NSString *name;/**<  名称 */
@property (nonatomic, strong) NSString *msgContent;/**<  消息内容 */
@property (nonatomic, strong) NSString *iconURL;/**<  头像 */

@property (nonatomic, assign) long long userId;

@property (nonatomic, assign) int messageNumber;/**< 消息数  */ 

@property (nonatomic, strong) MYUser *model;/**< model  */

- (void)convertFromDBModel:(MYDBUser *)model;

- (void)converFromUser:(MYUser *)user;

- (void)configNumberToZero;

@end

NS_ASSUME_NONNULL_END
