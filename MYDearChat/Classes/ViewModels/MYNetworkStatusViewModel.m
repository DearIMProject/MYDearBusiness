//
//  MYNetworkStatusViewModel.m
//  MYDearChat
//
//  Created by APPLE on 2023/12/7.
//

#import "MYNetworkStatusViewModel.h"

@implementation MYNetworkStatusViewModel

- (Class)itemViewClass {
    return NSClassFromString(@"MYNetworkStatusItemView");
}

-(CGSize)itemSize {
    if (self.networkConnectSuccess) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 40);
}

@end
