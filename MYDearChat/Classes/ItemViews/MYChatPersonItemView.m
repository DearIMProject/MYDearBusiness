//
//  MYChatPersonItemView.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYChatPersonItemView.h"
#import <SDWebImage/SDWebImage.h>
#import "MYChatPersonViewModel.h"
#import <MYRouter/MYRouter.h>

@interface MYChatPersonItemView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;/**<  头像 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;/**<  名称 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;/**<  内容 */
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *msgNumberBtn;/**< 消息数量  */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;/**< 时间  */

@property (nonatomic, strong) MYChatPersonViewModel *viewModel;

@end

@implementation MYChatPersonItemView
@dynamic viewModel;

#pragma mark - dealloc
#pragma mark - life cycle

+ (instancetype)itemView {
    return [self itemViewWithBundleName:@"MYDearChat"];
}

#pragma mark - Event Response

- (void)setViewModel:(MYChatPersonViewModel *)viewModel {
    [super setViewModel:viewModel];
    if (![viewModel isKindOfClass:MYChatPersonViewModel.class]) {
        return;
    }
    self.nameLabel.text = viewModel.name;
    self.contentLabel.text = viewModel.msgContent;
    NSString *iconURL = viewModel.iconURL;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL]];
    if (viewModel.messageNumber) {
        self.msgNumberBtn.hidden = NO;
        [self.msgNumberBtn setTitle:[NSString stringWithFormat:@"%d",viewModel.messageNumber] forState:UIControlStateNormal];
    } else {
        self.msgNumberBtn.hidden = YES;
    }
}

- (void)onSelected {
    NSMutableDictionary *dict = @{}.mutableCopy;
    //TODO: wmy 这里需要把tab的消息减少
    [self.viewModel configNumberToZero];
    dict[@"viewModel"] = self.viewModel;
    [MYRouter routerURL:@"dearim://messagelist" withParameters:dict];
}

#pragma mark - private methods
#pragma mark - getters & setters & init members


@end
