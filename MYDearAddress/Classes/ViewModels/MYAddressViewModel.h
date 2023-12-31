//
//  MYAddressViewModel.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import <MYMVVM/MYMVVM.h>
#import <MYClientDatabase/MYClientDatabase.h>
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYAddressViewModel : MYViewModel

@property (nonatomic, strong) NSString *name;/**<  名称 */
@property (nonatomic, strong) NSString *msgContent;/**<  消息内容 */
@property (nonatomic, strong) NSString *iconURL;/**<  头像 */

@property (nonatomic, assign) long long userId;

@property (nonatomic, strong) MYUser *model;/**< model  */

- (void)convertFromDBModel:(MYDBUser *)model;

- (void)converFromUser:(MYUser *)user;

- (void)addChatPerson;

@end

NS_ASSUME_NONNULL_END
