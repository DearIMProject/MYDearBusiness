//
//  MYRegisterViewController.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/2.
//

#import "MYRegisterViewController.h"
#import <MYUIKit/MYUIKit.h>
#import "MYViewController+MYRouter.h"
#import "MYLoginService.h"

@interface MYRegisterViewController ()


@property (nonatomic, strong) UILabel *titleLabel;/**<  标题 */
@property (nonatomic, strong) UITextField *emailTextField;/**<  电子邮箱登录 */
@property (nonatomic, strong) UITextField *pwdTextField;/**<  密码 */
@property (nonatomic, strong) UITextField *confirmPwdTextField;/**<  密码 */
@property (nonatomic, strong) UIButton *registerBtn;/**<  注册 */

@property (nonatomic, strong) MYLoginService *service;

@end

@implementation MYRegisterViewController

__MY_ROUTER_REGISTER__

#pragma mark - dealloc
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.emailTextField.text = self.email;
#if DEBUG
    self.emailTextField.text = @"305662816@qq.com";
    self.pwdTextField.text = @"apple";
    self.confirmPwdTextField.text = @"apple";
#endif
}

- (void)initView {
    self.view.backgroundColor = TheSkin.whiteColor;
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.pwdTextField];
    [self.view addSubview:self.confirmPwdTextField];
    [self.view addSubview:self.registerBtn];
     
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(MY_NaviBarHeight() + 60);
    }];
    
    
    
    CGFloat space = 3;
    CGFloat height = 45;
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(space);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
    }];
    
    [self.confirmPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.equalTo(self.pwdTextField.mas_bottom).offset(space);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TheSkin.space * 2);
        make.right.mas_equalTo(-TheSkin.space * 2);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.confirmPwdTextField.mas_bottom).offset(40);
    }];
    
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (self.emailTextField.text.length && self.pwdTextField.text.length && self.confirmPwdTextField.text.length) {
        self.registerBtn.enabled = YES;
    } else {
        self.registerBtn.enabled = NO;
    }
    
}

#pragma mark - CustomDelegate
#pragma mark - Event Response

- (void)onCLickRegister {
    [MBProgressHUD showLoadingToView:self.view];
    @weakify(self);
    
    [self.service registWithEmail:self.emailTextField.text
                         password:self.pwdTextField.text
                  confirmPassword:self.confirmPwdTextField.text
                          success:^{
        [MBProgressHUD hideHUDForView:self.view];
        @strongify(self);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"email"] = self.emailTextField.text;
        
        param[@"block"] = ^{
            [MYApplicationManager.shared refreshRootViewController];
        };
        [MYRouter routerURL:@"dearim://securityCode" withParameters:param];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error toView:self.view];
    }];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.backgroundColor = TheSkin.whiteColor;
        NSString *str = NSLocalizedString(@"input_password", nil);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr setAttributes:@{
            NSFontAttributeName : TheSkin.descTitleFont,
            NSForegroundColorAttributeName: TheSkin.descColor
        } range:NSMakeRange(0, str.length)];
        _pwdTextField.attributedPlaceholder = attr;
        _pwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TheSkin.halfSpace, 0)];
        _pwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.layer.borderWidth = 1;
        _pwdTextField.layer.borderColor = TheSkin.themeColor.CGColor;
    }
    return _pwdTextField;
}

- (UITextField *)confirmPwdTextField {
    if (!_confirmPwdTextField) {
        _confirmPwdTextField = [[UITextField alloc] init];
        _confirmPwdTextField.backgroundColor = TheSkin.whiteColor;
        NSString *str = NSLocalizedString(@"input_confirm_password", nil);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr setAttributes:@{
            NSFontAttributeName : TheSkin.descTitleFont,
            NSForegroundColorAttributeName: TheSkin.descColor
        } range:NSMakeRange(0, str.length)];
        _confirmPwdTextField.attributedPlaceholder = attr;
        _confirmPwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TheSkin.halfSpace, 0)];
        _confirmPwdTextField.leftViewMode = UITextFieldViewModeAlways;
        _confirmPwdTextField.secureTextEntry = YES;
        _confirmPwdTextField.delegate = self;
        _confirmPwdTextField.layer.borderWidth = 1;
        _confirmPwdTextField.layer.borderColor = TheSkin.themeColor.CGColor;
    }
    return _confirmPwdTextField;
}

- (UITextField *)emailTextField {
    if (!_emailTextField) {
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.backgroundColor = TheSkin.whiteColor;
        
        NSString *str = NSLocalizedString(@"input_email", nil);
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
        _emailTextField.layer.borderWidth = 1;
        _emailTextField.layer.borderColor = TheSkin.themeColor.CGColor;
    }
    return _emailTextField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TheSkin.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
        _titleLabel.text = NSLocalizedString(@"register", nil);
    }
    return _titleLabel;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setBackgroundImage:[UIImage my_imageWithColor:TheSkin.themeColor]
                                forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage my_imageWithColor:[TheSkin.themeColor colorWithOpacity:0.5]]
                                forState:UIControlStateDisabled];
        [_registerBtn setTitleColor:TheSkin.whiteColor forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = TheSkin.titleFont;
        [_registerBtn setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(onCLickRegister) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.enabled = NO;
    }
    return _registerBtn;
}
- (MYLoginService *)service {
    if (!_service) {
        _service = [[MYLoginService alloc] init];
    }
    return _service;
}

#pragma mark - router

+ (NSArray<NSString *> *)my_routerName {
    return @[
        @"register"
    ];
}

+ (void)my_handlerRouter:(NSString *)router param:(NSDictionary *)param {
    MYRegisterViewController *vc = [[MYRegisterViewController alloc] init];
    vc.email = param[@"email"];
    [MY_TopViewController().navigationController pushViewController:vc animated:YES];
}



@end
