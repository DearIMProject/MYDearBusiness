//
//  MYProfileViewController.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/3.
//

#import "MYTableViewController.h"
#import <MYDearBusiness/MYDearBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYProfileViewController : MYTableViewController <MYHomeTabViewControllerProtocol>

@property (nonatomic, strong) MYInteractor *interactor;

@end

NS_ASSUME_NONNULL_END
