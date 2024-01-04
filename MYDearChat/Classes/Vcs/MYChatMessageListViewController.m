//
//  MYChatMessageListViewController.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/17.
//

#import "MYChatMessageListViewController.h"
#import <MYUIKit/MYUIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MYViewController+MYRouter.h"
#import "MYChatMessageDataSource.h"
#import "MYChatTextView.h"
#import "MYChatManager.h"


@interface MYChatMessageListViewController () <MYChatTextViewDelegate,MYChatManagerDelegate>

@property(nonatomic, strong) MYChatMessageDataSource *datasource;

@property(nonatomic, strong) MYChatTextView *textView;

@property (nonatomic, assign) BOOL isKeyBoardShow;

@end

@implementation MYChatMessageListViewController

__MY_ROUTER_REGISTER__

#pragma mark - dealloc

- (void)dealloc {
    [theChatManager removeChatDelegate:self];
}
#pragma mark - life cycle

- (instancetype)initWithParam:(NSDictionary *)param {
    if (self = [super initWithParam:param]) {
        self.viewModel = param[@"viewModel"];
        self.datasource.viewModel = self.viewModel;
        self.interactor = param[@"interactor"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [theChatManager addChatDelegate:self];
    self.view.backgroundColor = kPageBackgroundColor;
    [self initView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    IQKeyboardManager.sharedManager.enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    IQKeyboardManager.sharedManager.enable = YES;
}

- (void)initView {
    if (!self.interactor) {
        _interactor = [[MYInteractor alloc] init];
    }
    self.autolayoutDelegate.interactor = self.interactor;
    self.tableView.dataSource = self.autolayoutDelegate;
    self.tableView.delegate = self.autolayoutDelegate;
    self.autolayoutDelegate.dataSource = self.datasource;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(64 + kSafeArea_Bottom);
//        make.height.mas_lessThanOrEqualTo(200 + kSafeArea_Bottom);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.textView.mas_top);
    }];
}

- (void)initData {
    
    @weakify(self);
    self.datasource.successBlock = ^{
        @strongify(self);
        [self reloadData];
    };
    self.datasource.failBlock = ^(NSError *_Nonnull error) {
        @strongify(self);
        [self reloadData];
    };
    [self.datasource request];

    [self addKeyboardNotification];
    
}

- (void)reloadData {
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottom];
    });
}

// 滚动到底部
- (void)scrollToBottom {
    int count = self.datasource.sectionModels.firstObject.viewModels.count;
    if (count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void)addKeyboardNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onReceiveKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onReceiveKeyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onReceiveKeyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}



#pragma mark - Notification

- (void)onReceiveKeyboardDidChange:(NSNotification *)aNotification {
    NSValue *value = [[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    float animationDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [self.view.window.screen bounds];//屏幕尺寸
    CGRect viewFrame = self.view.frame;
    CGRect textViewFrame = self.textView.frame;
    if (self.isKeyBoardShow) {
        viewFrame.size.height = frame.size.height - keyboardHeight - kSafeAreaNavBarHeight;
        textViewFrame.size.height = 64;
    } else {
        viewFrame.size.height = frame.size.height - kSafeAreaNavBarHeight;
        textViewFrame.size.height = 64 + kSafeArea_Bottom;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = viewFrame;
        self.textView.frame = textViewFrame;
    }];
}

- (void)onReceiveKeyboardWillShow:(NSNotification *)aNotification {
    self.isKeyBoardShow = YES;
    //TODO: wmy 后期来改善UI问题
}

- (void)onReceiveKeyboardDidHide:(NSNotification *)aNotification {
    self.isKeyBoardShow = NO;
}
#pragma mark - MYChatTextViewDelegate

- (void)textView:(MYChatTextView *)textView didClickSendButtonWithText:(NSString *)text {
    [self.datasource sendMessageContent:text];
}

#pragma mark - MYChatManagerDelegate

- (void)chatManager:(MYChatManager *)manager didReceiveMessage:(MYMessage *)message fromUser:(MYUser *)user {
    NSLog(@"content:%@",message.content);
    message.sendStatus = MYMessageStatus_Success;
    [self.datasource addChatMessage:message withUser:user];
}

- (void)chatManager:(MYChatManager *)manager sendMessageSuccessWithTag:(long)tag messageId:(long long)messageId {
    [self.datasource successMessageWithTag:tag messageId:messageId];
}

#pragma mark - Event Response
#pragma mark - private methods
#pragma mark - getters & setters & init members

+ (NSString *)urlName {
    return @"messagelist";
}

- (MYChatMessageDataSource *)datasource {
    if (!_datasource) {
        _datasource = [[MYChatMessageDataSource alloc] init];
    }
    return _datasource;
}

- (MYChatTextView *)textView {
    if (!_textView) {
        _textView = [[MYChatTextView alloc] init];
        _textView.backgroundColor = kWhiteColor;
        _textView.delegate = self;
    }
    return _textView;
}



@end
