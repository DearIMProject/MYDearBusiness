//
//  MYUser+MYConvert.h
//  DearIMProject
//
//  Created by APPLE on 2023/11/22.
//

#import <MYDearUser/MYDearUser.h>
#import <MYClientDatabase/MYClientDatabase.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYUser (MYConvert)

+ (instancetype)convertFromDBModel:(MYDBUser *)dbModel;

@end

@interface MYDBUser (MYConvert)

+ (instancetype)convertFromUser:(MYUser *)user;

@end

NS_ASSUME_NONNULL_END
