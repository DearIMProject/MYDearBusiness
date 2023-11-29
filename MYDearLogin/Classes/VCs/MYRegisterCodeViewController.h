//
//  MYRegisterCodeViewController.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/29.
//  确认验证码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestSuccessBlock)(void);

@interface MYRegisterCodeViewController : UIViewController

@property (nonatomic, copy) NSString *email;

@property(nonatomic, copy) RequestSuccessBlock block;

@end

NS_ASSUME_NONNULL_END
