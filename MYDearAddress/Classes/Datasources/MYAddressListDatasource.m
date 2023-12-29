//
//  MYAddressListDatasource.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import "MYAddressListDatasource.h"
#import <MYDearBusiness/MYDearBusiness.h>
#import "MYAddressViewModel.h"
#import "MYAddressService.h"
#import "MYAddressViewModel.h"

@interface MYAddressListDatasource ()

@property (nonatomic, strong) NSMutableArray<MYAddressViewModel *> *viewModels;
@property (nonatomic, strong) MYSectionModel *sectionModel; 
@property (nonatomic, strong) MYAddressService *service;

@end

@implementation MYAddressListDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionModel = [[MYSectionModel alloc] init];
        self.sectionModels = @[self.sectionModel];
        _viewModels = [NSMutableArray array];
        _service = [[MYAddressService alloc] init];
        _sectionModel.viewModels = self.viewModels;
    }
    return self;
}

- (void)request {
    @weakify(self);
    [self.service getAllAddressListWithSuccess:^(NSArray<MYUser *> * _Nonnull users) {
        @strongify(self);
        [self.viewModels removeAllObjects];
        for (MYUser *user in users) {
            MYAddressViewModel *vm = [[MYAddressViewModel alloc] init];
            [vm converFromUser:user];
            [self.viewModels addObject:vm];
        }
        //TODO: wmy 保存到本地
        if (self.successBlock) self.successBlock();
        
        
    } failure:self.failBlock];
}




@end
