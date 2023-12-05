//
//  MYIconProfileViewModel.h
//  MYDearProfile
//
//  Created by APPLE on 2023/12/1.
//

#import <MYMVVM/MYMVVM.h>
#import <MYDearUser/MYDearUser.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYIconProfileViewModel : MYViewModel

@property (nonatomic, strong) NSString *username;/**<  用户名称 */
@property (nonatomic, strong) NSString *iconURL;/**<  用户头像 */
@property (nonatomic, strong) NSString *email;/**<  邮箱 */

- (void)convertFromUser:(MYUser *)user;

@end

NS_ASSUME_NONNULL_END
