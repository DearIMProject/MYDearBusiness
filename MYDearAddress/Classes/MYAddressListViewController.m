//
//  MYAddressListViewController.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "MYAddressListDatasource.h"

@interface MYAddressListViewController ()
@property (nonatomic, strong) MYAddressListDatasource *datasource;

@end

@implementation MYAddressListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.tabBarItem.title = @"addressbook".local;
        self.title = @"addressbook".local;
        self.tabBarItem.image = [UIImage systemImageNamed:@"book"];
        self.tabBarItem.selectedImage = [UIImage systemImageNamed:@"book.fill"];
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
    self.datasource.interactor = self.interactor;
    @weakify(self);
    self.datasource.successBlock = ^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView reloadData];
    };
    self.datasource.failBlock = ^(NSError * _Nonnull error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.domain toView:self.view];
    };
    [MBProgressHUD showLoadingToView:self.view];
    [self.datasource request];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)initView {
    self.tableViewDelegate.dataSource = self.datasource;
    @weakify(self);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.datasource request];
    }];
}

- (MYAddressListDatasource *)datasource {
    if (!_datasource) {
        _datasource = [[MYAddressListDatasource alloc] init];
    }
    return _datasource;
}

@end
