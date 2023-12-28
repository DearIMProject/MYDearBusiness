//
//  MYChatPersonListViewController.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/3.
//

#import "MYChatPersonListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MYDearBusiness/MYDearBusiness.h>
#import "MYChatPersonDataSource.h"

@interface MYChatPersonListViewController () <MYChatManagerDelegate>

@property (nonatomic, strong) MYChatPersonDataSource *dataSources;
@property (nonatomic, assign) NSInteger chatNumber;/**< 左下角数字  */

@end

@implementation MYChatPersonListViewController

#pragma mark - dealloc

- (void)dealloc {
    [theChatManager removeChatDelegate:self];
}

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"chat".local;
        self.tabBarItem.title = @"chat".local;
        self.tabBarItem.image = [UIImage systemImageNamed:@"lanyardcard"];
        self.tabBarItem.selectedImage = [UIImage systemImageNamed:@"lanyardcard.fill"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initData {
    self.tableViewDelegate.interactor = self.interactor;
    self.dataSources.interactor = self.interactor;
    
    [theChatManager addChatDelegate:self];
    
    @weakify(self);
    [MBProgressHUD showLoadingToView:self.view];
    self.dataSources.successBlock = ^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView reloadData];
        if (!self.dataSources.sectionModels.firstObject.viewModels.count) {
            [MYRouter routerURL:@"changeTabAddressbook" withParameters:nil];
        }
    };
    self.dataSources.failureBlock = ^(NSError * _Nonnull error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.domain toView:self.view];
    };
    [self.dataSources request];
}

- (void)initView {
    self.title = @"chat".local;
    self.tableViewDelegate.dataSource = self.dataSources;
    @weakify(self);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.dataSources request];
    }];
}

#pragma mark - UITableViewDelegate
#pragma mark - MYChatManagerDelegate

- (void)chatManager:(MYChatManager *)manager didReceiveMessage:(MYMessage *)message fromUser:(MYUser *)user {
    // 加1
    self.chatNumber++;
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",self.chatNumber];
    [self.dataSources addMessage:message fromUser:user];
}
#pragma mark - Event Response
#pragma mark - private methods
#pragma mark - getters & setters & init members

- (MYChatPersonDataSource *)dataSources {
    if (!_dataSources) {
        _dataSources = [[MYChatPersonDataSource alloc] init];
    }
    return _dataSources;
}

@end
