//
//  MYChatAnotherMessageItemView.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/21.
//

#import "MYChatAnotherMessageItemView.h"
#import <MYUIKit/MYUIKit.h>
#import <MYDearBusiness/MYDearBusiness.h>
#import <SDWebImage/SDWebImage.h>
#import "MYChatMessageViewModel.h"

@interface MYChatAnotherMessageItemView ()

@property(nonatomic, strong) UILabel *contentLabel;/**< 内容  */
@property (nonatomic, strong) UIView *contentView;/**<  内容外围 */
@property(nonatomic, strong) MYChatMessageViewModel *viewModel;
@property(nonatomic, strong) UIImageView *iconImageView;/**<  头像 */
@property(nonatomic, strong) UIStackView *stackView;

@end

@implementation MYChatAnotherMessageItemView
@dynamic viewModel;

#pragma mark - dealloc

- (void)dealloc {
    [self.interactor unregisterTarget:self forEventName:kCanRecordMesssageTagEventName];
}
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
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(kMargin);
        make.bottom.mas_equalTo(-kMargin);
        make.right.mas_equalTo(-kMargin);
    }];
}

#pragma mark - Event Response

- (void)setViewModel:(MYChatMessageViewModel *)viewModel {
    [super setViewModel:viewModel];
    if (![viewModel isKindOfClass:MYChatMessageViewModel.class]) {
        return;
    }
    self.contentLabel.text = viewModel.content;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.iconURL]];
    self.contentView.backgroundColor = kWhiteColor;
    self.contentLabel.textColor = kBlackColor;
    self.stackView.alignment = UIStackViewAlignmentLeading;
    if (!self.viewModel.readed  && !self.viewModel.hasSendReadedMessage) {
        //TODO: wmy 这里还有需要判断是否之前就已经已读了
        [MYLog debug:self.viewModel.content];
        // 这里做已读消息
        [theChatManager sendContext:[NSString stringWithFormat:@"%lld",self.viewModel.model.timestamp]
                             toUser:viewModel.dataChatPerson withMsgType:MYMessageType_READED_MESSAGE];
        self.viewModel.hasSendReadedMessage = YES;
    }
}

//
//- (void)setInteractor:(MYInteractor *)interactor {
//    [super setInteractor:interactor];
//    [interactor registerTarget:self action:@selector(onReceiveRecordMessageTag) forEventName:kCanRecordMesssageTagEventName];
//}

- (void)onReceiveRecordMessageTag {
    self.viewModel.canRecordShow = YES;
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        [_stackView addArrangedSubview:self.iconImageView];
        [_stackView addArrangedSubview:self.contentView];
        [_stackView addArrangedSubview:UIView.new];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = kMargin * 0.5;
        _stackView.alignment = UIStackViewAlignmentLeading;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kSecondIconWidth);
        }];
        self.iconImageView.layer.cornerRadius = kSecondIconWidth * 0.5;
        [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _stackView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.clipsToBounds = YES;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView addSubview:self.contentLabel];
        _contentView.layer.cornerRadius = kSpace;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _contentView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}
@end
