//
//  MYDebugView.m
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDebugView.h"
#import <Masonry/Masonry.h>
#import <MYUIKit/MYUIKit.h>

@interface MYDebugView ()

@property (nonatomic, strong) UILabel *dLabel;

@end

@implementation MYDebugView


#pragma mark - dealloc
#pragma mark - life cycle

- (void)initView {
    self.backgroundColor = [UIColor.lightGrayColor colorWithOpacity:0.4];
#if DEBUG
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor redColor].CGColor;
#endif
    [self addSubview:self.dLabel];
    [self.dLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.center.mas_equalTo(self);
    }];
    self.layer.cornerRadius = 10;
}


+ (instancetype)viewInWindow:(UIWindow *)window {
    MYDebugView *view = [[MYDebugView alloc] init];
    [view initView];
    //TODO: wmy 获取当前window，然后添加到window中。
    [window addSubview:view];
    [view bringSubviewToFront:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.left.mas_equalTo(window);
    }];
    return view;
}
#pragma mark - Event Response

- (void)moveViewWithPoint:(CGPoint)point {
    CGPoint center = self.center;
    center.x = point.x;
    center.y = point.y;
    self.my_centerX = point.x;
    self.my_centerY = point.y;
}

- (void)moveEnd {
    CGFloat diffX = MY_ScreenWidth() - self.my_centerX;
    CGFloat end = 0;
    
    if (diffX < self.my_centerX)  {
        end = MY_ScreenWidth();
    }
    [UIView animateWithDuration:0.35 animations:^{
        if (end) {
            self.my_right = end;
        } else {
            self.my_left = 0;
        }
    }];
    
}

#pragma mark - private methods
#pragma mark - getters & setters & init members

- (UILabel *)dLabel {
    if (!_dLabel) {
        _dLabel = [[UILabel alloc] init];
        _dLabel.textColor = UIColor.orangeColor;
        _dLabel.font = [UIFont systemFontOfSize:28];
        _dLabel.text = @"D";
        _dLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _dLabel;
}


@end
