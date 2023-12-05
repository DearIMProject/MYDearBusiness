//
//  MYChatPersonItemView.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYChatPersonItemView.h"
#import <SDWebImage/SDWebImage.h>
#import "MYChatPersonViewModel.h"
#import <MYRouter/MYRouter.h>

@interface MYChatPersonItemView ()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;/**<  头像 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;/**<  名称 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;/**<  内容 */
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *msgNumberBtn;/**< 消息数量  */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;/**< 时间  */

@property (nonatomic, strong) MYChatPersonViewModel *viewModel;

@end

@implementation MYChatPersonItemView
@dynamic viewModel;

#pragma mark - dealloc
#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
//    [self addSubview:self.stackView];
//    [self addSubview:self.iconImageView];
//    [self addSubview:self.msgNumberBtn];
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
//    [self.msgNumberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-kMargin);
//        make.centerY.mas_equalTo(self);
//    }];
    
}

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearChat"];
}

#pragma mark - Event Response

- (void)setViewModel:(MYChatPersonViewModel *)viewModel {
    [super setViewModel:viewModel];
    if (![viewModel isKindOfClass:MYChatPersonViewModel.class]) {
        return;
    }
    self.nameLabel.text = viewModel.name;
    self.contentLabel.text = viewModel.msgContent;
    NSString *iconURL = viewModel.iconURL;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    if (viewModel.messageNumber) {
        self.msgNumberBtn.hidden = NO;
        [self.msgNumberBtn setTitle:[NSString stringWithFormat:@"%d",viewModel.messageNumber] forState:UIControlStateNormal];
    } else {
        self.msgNumberBtn.hidden = YES;
    }
}

- (void)onSelected {
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"viewModel"] = self.viewModel;
    [MYRouter routerURL:@"dearim://messagelist" withParameters:dict];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

//- (UIStackView *)stackView {
//    if (!_stackView) {
//        _stackView = [[UIStackView alloc] init];
//        _stackView.axis = UILayoutConstraintAxisVertical;
//        [_stackView addArrangedSubview:self.nameLabel];
//        [_stackView addArrangedSubview:self.contentLabel];
//        _stackView.spacing = kSpace;
//    }
//    return _stackView;
//}
//
//- (UIImageView *)iconImageView {
//    if (!_iconImageView) {
//        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.layer.cornerRadius = kSpace;
//    }
//    return _iconImageView;
//}
//
//- (UILabel *)nameLabel {
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.textColor = kBlackColor;
//        _nameLabel.font = [UIFont systemFontOfSize:14];
//    }
//    return _nameLabel;
//}
//
//- (UILabel *)contentLabel {
//    if (!_contentLabel) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.textColor = kBlackColor;
//        _contentLabel.font = [UIFont systemFontOfSize:14];
//    }
//    return _contentLabel;
//}
//- (UIButton *)msgNumberBtn {
//    if (!_msgNumberBtn) {
//        _msgNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_msgNumberBtn setBackgroundColor:TheSkin.warnColor];
//        _msgNumberBtn.layer.cornerRadius = 5;
//    }
//    return _msgNumberBtn;
//}

@end
