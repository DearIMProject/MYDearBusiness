//
//  MYSecurityCodeView.m
//  MYBookkeeping
//
//  Created by WenMingYan on 2022/1/30.
//

#import "MYSecurityCodeView.h"
#import <Masonry/Masonry.h>
#import <MYUtils/MYUtils.h>
#import "MYSkinManager.h"
//#import "MYFoundationKit.h"

typedef void(^ClickDeleteBlock)(void);

@interface _MYTextField : UITextField

@property(nonatomic, copy) ClickDeleteBlock deleteBlock;

@end

@implementation _MYTextField

- (void)deleteBackward {
    [super deleteBackward];
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end

@interface MYSecurityCodeView () <UITextFieldDelegate>

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSArray<_MYTextField *> *textFields;

@end

@implementation MYSecurityCodeView


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

- (NSArray<_MYTextField *> *)configTextFields {
    NSInteger count = 6;
    NSMutableArray<_MYTextField *> *textFields =
    [NSMutableArray<_MYTextField *> arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        _MYTextField *textField = [self configTextField];
        textField.tag = i;
        [textFields addObject:textField];
        if (i == 0) {
            [textField becomeFirstResponder];
        }
    }
    self.textFields = textFields;
    return textFields;
}

- (void)initView {
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (_MYTextField *)configTextField {
    _MYTextField *textField = [[_MYTextField alloc] init];
    textField.delegate = self;
    textField.font = TheSkin.bigTitleFont;
    textField.textColor = TheSkin.titleColor;
    textField.layer.cornerRadius = 2;
    textField.layer.borderWidth = 1;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor = TheSkin.themeColor.CGColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    @weakify(self);
    @weakify(textField);
    textField.deleteBlock = ^{
        @strongify(self);
        @strongify(textField);
        if (textField.text.length == 0) {
            NSInteger tag = textField.tag - 1;
            [textField resignFirstResponder];
            UITextField *preText = [self.textFields my_safeObjectAtIndex:tag];
            if (preText) {
                [preText becomeFirstResponder];
            }
        }
    };
    return textField;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (BOOL)resignFirstResponder {
    for (UITextField *text in self.textFields) {
        [text resignFirstResponder];
    }
    return [super resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(_MYTextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    [str replaceCharactersInRange:range withString:string];
    if (str.length == 2) {
        NSInteger tag = textField.tag + 1;
        if (tag == 6) {
            // 键盘收起
            [self resignFirstResponder];
        } else {
            [textField endEditing:NO];
            UITextField *textField = [self.textFields my_safeObjectAtIndex:tag];
            textField.text = string;
            [textField becomeFirstResponder];
        }
    }
    if (str.length == 1) {
        textField.text = str;
        NSInteger tag = textField.tag + 1;
        if (tag == 6) {
            // 键盘收起
            [self resignFirstResponder];
        } else {
            [textField endEditing:NO];
            UITextField *textField = [self.textFields my_safeObjectAtIndex:tag];
            [textField becomeFirstResponder];
        }
        
        return NO;
    }
    if (str.length == 0) {
        textField.text = @"";
        NSInteger tag = textField.tag - 1;
        if (tag == -1) {
            // 键盘收起
            [self resignFirstResponder];
        } else {
            [textField endEditing:NO];
            UITextField *textField = [self.textFields my_safeObjectAtIndex:tag];
            [textField becomeFirstResponder];
        }
        return NO;
    }
    return NO;
}

#pragma mark - Event Response

- (NSString *)text {
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < self.textFields.count; ++i) {
        NSString *item = [self.textFields my_safeObjectAtIndex:i].text;
        [result appendString:item];
    }
    return [result copy];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.spacing = TheSkin.space;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        NSArray<UITextField *> *textFields = [self configTextFields];
        for (UITextField *textField in textFields) {
            [_stackView addArrangedSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.stackView);
            }];
        }
    }
    return _stackView;
}

@end
