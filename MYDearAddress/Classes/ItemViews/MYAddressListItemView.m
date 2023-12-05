//
//  MYAddressListItemView.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressListItemView.h"
#import <MYRouter/MYRouter.h>
#import <SDWebImage/SDWebImage.h>
#import "MYAddressViewModel.h"

@interface MYAddressListItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;/**<  头像 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/**<  名称 */
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;/**<  用户状态 */

@property (nonatomic, strong) MYAddressViewModel *viewModel;

@end

@implementation MYAddressListItemView

@dynamic viewModel;

#pragma mark - dealloc
#pragma mark - life cycle

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self initView];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self initView];
//    }
//    return self;
//}

//- (void)initView {
//    [self addSubview:self.stackView];
//    [self addSubview:self.iconImageView];
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(kIconWidth);
//        make.centerY.equalTo(self);
//        make.left.mas_equalTo(kMargin);
//    }];
//    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(kSpace);
//        make.right.mas_lessThanOrEqualTo(self).offset(-kMargin);
//        make.centerY.equalTo(self);
//    }];
//
//}

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearAddress"];
}

#pragma mark - Event Response

- (void)setViewModel:(MYAddressViewModel *)viewModel {
    [super setViewModel:viewModel];
    if (![viewModel isKindOfClass:MYAddressViewModel.class]) {
        return;
    }
    self.nameLabel.text = viewModel.name;
//    self.contentLabel.text = viewModel.msgContent;
    NSString *iconURL = viewModel.iconURL;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
}

- (void)onSelected {
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"viewModel"] = self.viewModel;
    [MYRouter routerURL:@"dearim://messagelist" withParameters:dict];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members


@end
