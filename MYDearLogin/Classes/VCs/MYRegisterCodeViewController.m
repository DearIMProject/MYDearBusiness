//
//  MYRegisterCodeViewController.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/29.
//

#import "MYRegisterCodeViewController.h"
#import "MYViewController+MYRouter.h"
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MYSecurityCodeView.h"
#import "MYLoginService.h"

@interface MYRegisterCodeViewController ()

@property (nonatomic, strong) UILabel *titleLabel;/**<  标题 */
@property (nonatomic, strong) UIButton *sureBtn;/**<  注册 */
@property (nonatomic, strong) MYSecurityCodeView *codeView;
@property (nonatomic, strong) MYLoginService *service;

@property (nonatomic, strong) NSTimer *timer;/**< 倒计时  */
@property (nonatomic, assign) int time;/**< 60s倒计时  */

@property (nonatomic, strong) UIButton *sendBtn;/**< 发送验证码  */


@end

@implementation MYRegisterCodeViewController

#pragma mark - dealloc
#pragma mark - life cycle

__MY_ROUTER_REGISTER__

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time = 60;
    self.view.backgroundColor = TheSkin.whiteColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.sendBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(kSafeAreaNavBarHeight + 100);
    }];
    CGFloat space = 45;
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(space);
        make.height.mas_equalTo(50);
    }];
    CGFloat height = 45;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.codeView.mas_bottom).offset(space);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sureBtn.mas_right);
        make.top.equalTo(self.sureBtn.mas_bottom).offset(TheSkin.halfSpace);
    }];
//    [self onClickSend];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    IQKeyboardManager.sharedManager.enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    IQKeyboardManager.sharedManager.enable = YES;
    [self endTimer];
}

#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
#pragma mark - Event Response

- (void)onClickSure {
    [MBProgressHUD showLoadingToView:self.view];
    @weakify(self);
    [self.service checkCode:self.codeView.text email:self.email success:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [TopViewController().navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.domain toView:self.view];
    }];
}

- (void)onClickSend {
    @weakify(self);
    [self.service sendCheckCode:self.email success:^{
     //TODO: wmy 已发送验证码 提示
        @strongify(self);
        self.sendBtn.enabled = YES;
        [self startTimer];
    } failure:^(NSError * _Nonnull error) {
        [MYLog debug:error.domain];
    }];
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self itemTimer];
    }];
    
}

- (void)endTimer {
    [self.timer timeInterval];
    _timer = nil;
    self.sendBtn.enabled = YES;
    [self.sendBtn setTitle:@"send security code".local
                  forState:UIControlStateNormal];
}

- (void)itemTimer {
    if (self.time < 0) {
        [self endTimer];
        return;
    }
    self.time--;
    self.sendBtn.enabled = NO;
    NSString *title = [NSString stringWithFormat:@"%@%ds",@"send security code".local,self.time];
    [self.sendBtn setTitle:title forState:UIControlStateNormal];
    if (self.time < 0) {
        [self endTimer];
    }
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = TheSkin.themeColor;
        [_sureBtn setTitleColor:TheSkin.whiteColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = TheSkin.titleFont;
        [_sureBtn setTitle:@"sure".local forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(onClickSure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TheSkin.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _titleLabel.text = @"input_securimy_code".local;
    }
    return _titleLabel;
}

- (MYSecurityCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[MYSecurityCodeView alloc] init];
    }
    return _codeView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitleColor:TheSkin.linkColor forState:UIControlStateNormal];
        [_sendBtn setTitleColor:TheSkin.descColor forState:UIControlStateDisabled];
        [_sendBtn setTitle:NSLocalizedString(@"send security code", nil)
                  forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = TheSkin.descTitleFont;
        [_sendBtn addTarget:self action:@selector(onClickSend)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (MYLoginService *)service {
    if (!_service) {
        _service = [[MYLoginService alloc] init];
    }
    return _service;
}

#pragma mark - router

+ (NSString *)urlName {
    return @"securityCode";
}

- (instancetype)initWithParam:(NSDictionary *)param {
    if (self = [super init]) {
        self.email = param[@"email"];
        self.block = [param[@"block"] copy];
    }
    return self;
}

@end
