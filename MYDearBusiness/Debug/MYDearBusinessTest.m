//
//  MYDearBusinessTest.m
//  MYDearBusiness
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDearBusinessTest.h"
#import <MYDearDebug/MYDearDebug.h>
#import <MYUtils/MYUtils.h>
#import "MYApplicationManager.h"
#import <MYNetwork/MYNetwork.h>

@implementation MYDearBusinessTest

+ (void)load {
    [TheDebug registDebugModule:@"network".local moduleItmes:@[
        [MYDebugItemModel modelWithName:@"设置ip地址" block:^{
        [self showAlert];
    }],
    ]];
}

+ (void)showAlert {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"设置IP地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    controller.title = @"设置ip地址";
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"sure".local style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *apiAddress = controller.textFields.firstObject.text;
        theNetworkManager.host = apiAddress;
        TheSocket.host = apiAddress;
        NSLog(@"text = %@",apiAddress);
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"cancel".local style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [TopViewController() presentViewController:controller animated:YES completion:nil];
}

@end
