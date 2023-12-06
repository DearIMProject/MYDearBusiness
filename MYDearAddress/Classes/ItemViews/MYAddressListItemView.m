//
//  MYAddressListItemView.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressListItemView.h"
#import <MYDearBusiness/MYDearBusiness.h>
#import "MYAddressViewModel.h"

@interface MYAddressListItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;/**<  头像 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;/**<  名称 */
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;/**<  用户状态 */

@property (nonatomic, strong) MYAddressViewModel *viewModel;

@end

@implementation MYAddressListItemView

@dynamic viewModel;

#pragma mark - dealloc
#pragma mark - life cycle

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearAddress"];
}

#pragma mark - Event Response

- (void)setViewModel:(MYAddressViewModel *)viewModel {
    [super setViewModel:viewModel];
    if (![viewModel isKindOfClass:MYAddressViewModel.class]) {
        return;
    }
    self.nameLabel.text = viewModel.name;
//    self.contentLabel.text = viewModel.msgContent;
    NSString *iconURL = viewModel.iconURL;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
}

- (void)onSelected {
    [self.interactor sendEventName:kClickAddressItemEventName withObjects:self.viewModel.model];
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"viewModel"] = self.viewModel;
    [MYRouter routerURL:@"dearim://messagelist" withParameters:dict];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members


@end
