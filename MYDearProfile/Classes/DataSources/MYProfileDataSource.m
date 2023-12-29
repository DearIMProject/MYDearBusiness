//
//  MYProfileDataSource.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYProfileDataSource.h"
#import "MYLoginService.h"
#import "MYProfileItemViewModel.h"
#import <MYRouter/MYRouter.h>
#import "MYIconProfileViewModel.h"

#import <MYDearUpload/MYDearUpload.h>

@interface MYProfileDataSource ()

@property (nonatomic, strong) MYLoginService *loginService;

@property (nonatomic, strong) MYSectionModel *profileSectionModel;

@property (nonatomic, strong) MYIconProfileViewModel *profileVM;

@property (nonatomic, strong) MYProfileItemViewModel *logoutViewModel;

@property (nonatomic, strong) MYProfileItemViewModel *testViewModel;

@property (nonatomic, strong) MYProfileItemViewModel *sendLogViewModel;/**< 发送日志到邮箱  */


@property (nonatomic, strong) MYUploadFileService *uploadService;/**< 上传服务  */

@end

@implementation MYProfileDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uploadService = [[MYUploadFileService alloc] init];
        
        _loginService = [[MYLoginService alloc] init];
        _profileSectionModel = [[MYSectionModel alloc] init];
        self.sectionModels = @[self.profileSectionModel];
        _logoutViewModel = [[MYProfileItemViewModel alloc] init];
        _logoutViewModel.title = @"logout".local;
        
        
        _sendLogViewModel = [[MYProfileItemViewModel alloc] init];
        _sendLogViewModel.title = @"send_log".local;
        @weakify(self);
        _sendLogViewModel.selectBlock = ^{
            @strongify(self);
            [self sendLog];
        };
        
        _profileVM = [[MYIconProfileViewModel alloc] init];
        
#if DEBUG
        _testViewModel = [[MYProfileItemViewModel alloc] init];
        _testViewModel.title = @"test".local;
        
        _testViewModel.selectBlock = ^{
            @strongify(self);
            [self jumpTestPage];
        };
#endif
        
        _logoutViewModel.selectBlock = ^{
            @strongify(self);
            [self logout];
        };
        
#if DEBUG
        _profileSectionModel.viewModels = @[self.profileVM,self.sendLogViewModel,self.testViewModel, self.logoutViewModel];
#else
        _profileSectionModel.viewModels = @[self.profileVM,self.sendLogViewModel,self.logoutViewModel];
#endif
        
    }
    return self;
}

- (void)sendLog {
    // 发送日志
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];

    NSArray<NSString *> *logFilePaths = [fileLogger.logFileManager sortedLogFilePaths];
    for (NSString *logFilePath in logFilePaths) {
        NSLog(@"日志文件路径: %@", logFilePath);
    }
    @weakify(self);
    [self.uploadService uploadFilePath:logFilePaths.firstObject withprogress:^(CGFloat progress) {
        ;;
        NSLog(@"上传进度: %f", progress);
    } success:^{
        @strongify(self);
        [self.interactor sendEventName:kProfileUploadSuccessEvent withObjects:@"send_success".local];
    } failure:^(NSError * _Nonnull error) {
        [self.interactor sendEventName:kProfileUploadSuccessEvent withObjects:error.domain];
        NSLog(@"上传失败！error = %@",error);
    }];
    
}

- (void)jumpTestPage {
    //TODO: wmy
    [MYRouter routerURL:@"testpage" withParameters:nil];
}

- (void)logout {
    if ([self.delegate respondsToSelector:@selector(requestBegin:)]) {
        [self.delegate requestBegin:self];
    }
    @weakify(self);
    [self.loginService logoutWithSuccess:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(logoutServiceSuccess:error:)]) {
            [self.delegate logoutServiceSuccess:YES error:nil];
        }
    } failure:^(NSError * _Nonnull error) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(logoutServiceSuccess:error:)]) {
            [self.delegate logoutServiceSuccess:NO error:error];
        }
    }];
}

- (void)request {
    [self.profileVM convertFromUser:TheUserManager.user];
    if (self.successBlock) {
        self.successBlock();
    }
}

@end
