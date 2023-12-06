//
//  MYAddressListDatasource.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import <MYMVVM/MYMVVM.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYAddressListDatasource : MYDataSource

@property (nonatomic, strong) MYInteractor *interactor; /**< 交互层  */

@end

NS_ASSUME_NONNULL_END
