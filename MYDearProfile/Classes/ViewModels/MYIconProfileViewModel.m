//
//  MYIconProfileViewModel.m
//  MYDearProfile
//
//  Created by APPLE on 2023/12/1.
//

#import "MYIconProfileViewModel.h"

@implementation MYIconProfileViewModel

- (void)convertFromUser:(MYUser *)user {
    self.iconURL = user.icon;
    self.username = user.username;
    self.email = user.email;
}

- (Class)itemViewClass {
    return NSClassFromString(@"MYIconProfileItemView");
}

- (CGSize)itemSize {
    return CGSizeMake(0, 100);
}

@end
