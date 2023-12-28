//
//  MYNetworkStatusItemView.m
//  MYDearChat
//
//  Created by APPLE on 2023/12/7.
//

#import "MYNetworkStatusItemView.h"
#import "MYNetworkStatusViewModel.h"

@interface MYNetworkStatusItemView ()

@property (nonatomic, strong) MYNetworkStatusViewModel *viewModel;

@end

@implementation MYNetworkStatusItemView

@dynamic viewModel;

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearChat"];
}

- (void)setViewModel:(MYNetworkStatusViewModel *)viewModel {
    self.viewModel = viewModel;
    if (![viewModel isKindOfClass:MYNetworkStatusViewModel.class]) {
        return;
    }
    //TODO: wmy 
}
@end
