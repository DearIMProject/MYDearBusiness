//
//  MYAddressListViewController.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/27.
//

#import <MYMVVM/MYMVVM.h>
#import <MYDearBusiness/MYDearBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYAddressListViewController : MYTableViewController <MYHomeTabViewControllerProtocol>

@property (nonatomic, strong) MYInteractor *interactor;

@end

NS_ASSUME_NONNULL_END
