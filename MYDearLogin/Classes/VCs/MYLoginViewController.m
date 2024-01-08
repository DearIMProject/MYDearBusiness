//
//  MYLoginViewController.m
//  MYDearLogin
//
//  Created by APPLE on 2023/11/29.
//

#import "MYLoginViewController.h"
#import <Masonry/Masonry.h>
#import <MYSkin/MYSkin.h>
#import <MYUIKit/MYUIKit.h>
#import <MYDearBusiness/MYDearBusiness.h>
#import <MYRouter/MYRouter.h>
#import <MYDearUser/MYDearUser.h>
#import <MYDearApplication/MYApplicationManager.h>


@interface MYLoginViewController ()

@property (nonatomic, strong) MYLoginService *service;

@property (nonatomic, strong) UILabel *titleLabel;/**<  标题 */
@property (nonatomic, strong) UITextField *emailTextField;/**<  电子邮箱登录 */
@property (nonatomic, strong) UITextField *pwdTextField;/**<  密码 */

@property (nonatomic, strong) UIButton *loginBtn;/**<  登录 */

@property (nonatomic, strong) UIButton *registerBtn;/**< 注册  */
@property (nonatomic, strong) UIButton *fgtPwdBtn;/**< 忘记密码  */

@end

@implementation MYLoginViewController

#pragma mark - dealloc
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    self.view.backgroundColor = TheSkin.themeColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.fgtPwdBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(MY_NaviBarHeight() + 60);
    }];
    
    CGFloat height = 45;
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(60);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
    }];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(1);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(40);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginBtn.mas_right);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(TheSkin.halfSpace);
    }];
    [self.fgtPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.registerBtn.mas_left).offset(-TheSkin.space);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(TheSkin.halfSpace);
    }];
    
    [self.emailTextField becomeFirstResponder];
    
    //TODO: wmy
#if DEBUG
    self.emailTextField.text = @"iphonex@apple.com";// iphonex
//    self.emailTextField.text = @"305662816@qq.com";// iphonexs
//    self.emailTextField.text = @"simulator@apple.com";// 模拟器
    self.pwdTextField.text = @"apple";
#endif
}

- (void)viewWillAppear:(BOOL)animated{
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (self.emailTextField.text.length && self.pwdTextField.text.length) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}

#pragma mark - CustomDelegate
#pragma mark - Event Response

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onClickLogin {
    @weakify(self);
    [self.service loginWithEmail:self.emailTextField.text
                        password:self.pwdTextField.text
                         success:^{
        @strongify(self);
        [MBProgressHUD showTip:@"login success".local toView:self.view completion:^{
            [MYApplicationManager.shared refreshRootViewController];
        }];
    } failure:^(NSError * _Nonnull error) {
        @strongify(self);
        [MYLog debug:error.domain];
        [MBProgressHUD showError:error.domain toView:self.view];
    }];
}

- (void)onClickRegister {
    // 跳转到注册页面
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = self.emailTextField.text;
    [MYRouter routerURL:@"dearim://register" withParameters:param];
}

- (void)onClickFgtPwd {
    // 跳转到忘记密码页面
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"email"] = self.emailTextField.text;
    [MYRouter routerURL:@"dearim://fgtpwd" withParameters:param];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.backgroundColor = TheSkin.whiteColor;
        NSString *str = @"input_password".local;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr setAttributes:@{
            NSFontAttributeName : TheSkin.descTitleFont,
            NSForegroundColorAttributeName: TheSkin.descColor
        } range:NSMakeRange(0, str.length)];
        _pwdTextField.attributedPlaceholder = attr;
        _pwdTextField.leftView =
        [[UIView alloc]initWithFrame:CGRectMake(0, 0, TheSkin.halfSpace, 0)];
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}

- (UITextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.backgroundColor = TheSkin.whiteColor;
        
        NSString *str = @"input_email".local;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr setAttributes:@{
            NSFontAttributeName : TheSkin.descTitleFont,
            NSForegroundColorAttributeName: TheSkin.descColor
        } range:NSMakeRange(0, str.length)];
        _emailTextField.attributedPlaceholder = attr;
        _emailTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TheSkin.halfSpace, 0)];
        _emailTextField.leftViewMode = UITextFieldViewModeAlways;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.delegate = self;
    }
    return _emailTextField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TheSkin.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _titleLabel.text = @"login".local;
    }
    return _titleLabel;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundImage:[UIImage my_imageWithColor:TheSkin.blackColor]
                             forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage my_imageWithColor:[TheSkin.blackColor colorWithOpacity:0.5]]
                             forState:UIControlStateDisabled];
        [_loginBtn setTitleColor:TheSkin.whiteColor forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = TheSkin.titleFont;
        [_loginBtn setTitle:@"login".local forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"has_no_accrount".local forState:UIControlStateNormal];
        [_registerBtn setTitleColor:TheSkin.whiteColor forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = TheSkin.descTitleFont;
        [_registerBtn addTarget:self action:@selector(onClickRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)fgtPwdBtn {
    if (!_fgtPwdBtn) {
        _fgtPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fgtPwdBtn setTitle:@"forget_password".local forState:UIControlStateNormal];
        [_fgtPwdBtn setTitleColor:TheSkin.whiteColor forState:UIControlStateNormal];
        _fgtPwdBtn.titleLabel.font = TheSkin.descTitleFont;
        [_fgtPwdBtn addTarget:self action:@selector(onClickFgtPwd) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fgtPwdBtn;
}

- (MYLoginService *)service {
    if (!_service) {
        _service = [[MYLoginService alloc] init];
    }
    return _service;
}

@end
