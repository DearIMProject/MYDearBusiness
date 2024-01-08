//
//  MYDebugViewController.m
//  MYDearDebug
//
//  Created by APPLE on 2024/1/8.
//

#import "MYDebugViewController.h"
#import <Masonry/Masonry.h>
#import "MYDearDebug.h"

@interface MYDebugViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MYDebugViewController


#pragma mark - --------------------dealloc ------------------
#pragma mark - --------------------life cycle--------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)initView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dismissModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - --------------------UITableViewDelegate--------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    MYDebugItemModel *itemModel = [[TheDebug.models[indexPath.section] itemModels] objectAtIndex:indexPath.row];
    cell.textLabel.text = itemModel.itemName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MYDebugSectionModel *sectionModel = TheDebug.models[section];
    return sectionModel.itemModels.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TheDebug.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MYDebugItemModel *itemModel = [[TheDebug.models[indexPath.section] itemModels] objectAtIndex:indexPath.row];
    if (itemModel.block) {
        itemModel.block();
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MYDebugSectionModel *sectionModel = TheDebug.models[section];
    return sectionModel.moduleName;
}

#pragma mark - --------------------CustomDelegate--------------
#pragma mark - --------------------Event Response--------------
#pragma mark - --------------------private methods--------------
#pragma mark - --------------------getters & setters & init members ------------------

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.sectionHeaderHeight = 30;
    }
    return _tableView;
}


@end
