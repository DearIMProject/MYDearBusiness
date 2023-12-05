//
//  MYIconProfileItemView.m
//  MYDearProfile
//
//  Created by APPLE on 2023/12/1.
//

#import "MYIconProfileItemView.h"
#import <SDWebImage/SDWebImage.h>
#import "MYIconProfileViewModel.h"

@interface MYIconProfileItemView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) MYIconProfileViewModel *viewModel;

@end

@implementation MYIconProfileItemView

@dynamic viewModel;

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearProfile"];
}

- (void)setViewModel:(MYIconProfileViewModel *)viewModel {
    if (![viewModel isKindOfClass:MYIconProfileViewModel.class]) {
        return;
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.iconURL]];
    self.nameLabel.text = viewModel.username;
    self.emailLabel.text = viewModel.email;
}

@end
