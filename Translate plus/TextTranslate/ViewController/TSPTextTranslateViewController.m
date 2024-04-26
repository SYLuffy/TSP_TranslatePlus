//
//  TSPTextTranslateViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/19.
//

#import "TSPTextTranslateViewController.h"
#import "TSPCommonButton.h"
#import "TSPTextView.h"
#import "TSPTextTranslateResultViewViewController.h"
#import "TSPLanguageListViewController.h"

@interface TSPTextTranslateViewController () <TSPTranslatingProtocol>

@property (nonatomic, strong) UIView * topBgView;
@property (nonatomic, strong) TSPCommonButton * sourceLanguageButton;
@property (nonatomic, strong) TSPCommonButton * tartgetLanguageButton;
@property (nonatomic, strong) UIView * whiteBgView;
@property (nonatomic, strong) TSPTextView * inputTextView;
@property (nonatomic, strong) UIButton * exchangeButton;
@property (nonatomic, strong) UIButton * cleanTextButton;

@property (nonatomic, strong) UIView * translateBgView;
@property (nonatomic, strong) UIButton * translateButton;
@property (nonatomic, strong) NSString * sourceString;
@property (nonatomic, strong) NSString * targetString;
@property (nonatomic, assign) BOOL isTranslated;
@property (nonatomic, assign) BOOL isEnterBackground;

@end

@implementation TSPTextTranslateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)navTitle {
    return @"Text Translate";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLanguage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TSPTranslateManager instance] downloadDefaultLanguageModel];
    [self initializeAppearance];
    [TSPTranslateManager instance].isOcr = NO;
    self.isEnterBackground = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackGround:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForeGround:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
}

- (void)initializeAppearance {
    [TSPTranslateManager instance].isOcr = NO;
    [self.view addSubview:self.topBgView];
    [self.topBgView addSubview:self.sourceLanguageButton];
    [self.topBgView addSubview:self.tartgetLanguageButton];
    [self.topBgView addSubview:self.exchangeButton];
    [self.view addSubview:self.whiteBgView];
    [self.view addSubview:self.inputTextView];
    [self.view addSubview:self.cleanTextButton];
    [self.view addSubview:self.translateBgView];
    [self.translateBgView addSubview:self.translateButton];
    
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TSPAdapterHeight(56));
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
    
    [self.sourceLanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TSPAdapterHeight(18));
        make.right.mas_equalTo(self.topBgView.mas_centerX).offset(TSPAdapterHeight(-84));
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
    }];
    
    [self.tartgetLanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgView.mas_centerX).offset(TSPAdapterHeight(84));
        make.height.mas_equalTo(TSPAdapterHeight(18));
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topBgView.mas_centerX);
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
        make.width.height.mas_equalTo(TSPAdapterHeight(18));
    }];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
        make.bottom.mas_equalTo(self.translateBgView.mas_top);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.view.mas_right).offset(TSPAdapterHeight(-40));
        make.top.mas_equalTo(self.topBgView.mas_bottom);
        make.bottom.mas_equalTo(self.translateBgView.mas_top);
    }];
    
    [self.cleanTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(16));
        make.top.mas_equalTo(self.topBgView.mas_bottom).offset(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.navView.mas_right).offset(TSPAdapterHeight(-16));
    }];
    
    [self.translateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(TSPAdapterHeight(-259));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TSPAdapterHeight(84));
    }];
    
    [self.translateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.translateBgView.mas_centerX);
        make.top.mas_equalTo(self.translateBgView.mas_top).offset(TSPAdapterHeight(10));
        make.width.mas_equalTo(TSPAdapterHeight(224));
        make.height.mas_equalTo(TSPAdapterHeight(48));
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.inputTextView addTextDidChangeHandler:^(TSPTextView * _Nonnull textView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.cleanTextButton.hidden = textView.text.length > 0?NO:YES;
    }];
}

- (void)exchangeAction {
    [[TSPTranslateManager instance] exchangeLanguage:NO];
    [self updateLanguage];
}

- (void)updateLanguage {
    [self.sourceLanguageButton setTitle:[TSPTranslateManager instance].textSourceLanguage.language];
    [self.tartgetLanguageButton setTitle:[TSPTranslateManager instance].textTargetLanguage.language];
}

- (void)sourceAction {
    [TSPTranslateManager instance].isSource = YES;
    TSPLanguageListViewController * languageListVC = [[TSPLanguageListViewController alloc] init];
    languageListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:languageListVC animated:YES completion:nil];
}

- (void)tartgetAction {
    [TSPTranslateManager instance].isSource = NO;
    TSPLanguageListViewController * languageListVC = [[TSPLanguageListViewController alloc] init];
    languageListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:languageListVC animated:YES completion:nil];
}

- (void)translateAction:(UIButton *)sender {
    [self.inputTextView resignFirstResponder];
    NSString * string = self.inputTextView.text;
    NSString * realStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    [TSPTranslateManager instance].isOcr = NO;
    if (realStr && realStr.length > 0) {
        if (![[TSPTranslateManager instance] checkShowNetworkNotReachableToast]) {
            [TSPTranslatingView showTranslatingWithSuperView:self.view delegate:self];
            [[TSPTranslateManager instance] transLateWith:string completeBlcok:^(BOOL isSucces, NSString * _Nonnull result) {
                if (isSucces && result.length > 0 && !self.isEnterBackground) {
                    self.sourceString = string;
                    self.targetString = result;
                    self.isTranslated = YES;
                }else {
                    self.isTranslated = NO;
                }
            }];
        }
    }else {
        [TSPToast showMessage:@"Please input what needs to be translated." duration:3 finishHandler:nil];
        self.isTranslated = NO;
    }
}

- (void)loadingFinish {
    if (self.isEnterBackground) {
        self.isEnterBackground = NO;
        return;
    }
    if (self.isTranslated) {
        TSPTextTranslateResultViewViewController * resultVC = [[TSPTextTranslateResultViewViewController alloc] init];
        [resultVC setSourceString:self.sourceString resultString:self.targetString];
        resultVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:resultVC animated:YES completion:nil];
    }else {
        [TSPToast showMessage:@"Failed to translate." duration:3 finishHandler:nil];
    }
}

- (void)enterForeGround:(NSNotification *)noti {
    self.isEnterBackground = NO;
}

- (void)enterBackGround:(NSNotification *)noti {
    self.isEnterBackground = YES;
    self.isTranslated = NO;
    self.targetString = @"";
    [TSPTranslatingView stopTranslating];
}

- (void)cleanTextClick {
    self.inputTextView.text = @"";
}

- (void)handleBackClickEvent {
    if (self.isFormVpnResult) {
        [[UIApplication sharedApplication].windows.lastObject.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Getter

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [UIColor TSP_colorWithHex:0xff383838];
        _topBgView.userInteractionEnabled = YES;
    }
    return _topBgView;
}

- (TSPCommonButton *)sourceLanguageButton {
    if (!_sourceLanguageButton) {
        _sourceLanguageButton = [[TSPCommonButton alloc] initWithAlignment:TSPCommonAlignmentLeft];
        __weak typeof(self) weakSelf = self;
        _sourceLanguageButton.tapClick = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf sourceAction];
        };
    }
    return _sourceLanguageButton;
}

- (TSPCommonButton *)tartgetLanguageButton {
    if (!_tartgetLanguageButton) {
        _tartgetLanguageButton = [[TSPCommonButton alloc] initWithAlignment:TSPCommonAlignmentRight];
        __weak typeof(self) weakSelf = self;
        _tartgetLanguageButton.tapClick = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf tartgetAction];
        };
    }
    return _tartgetLanguageButton;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:@"hoem_texttranslate_reverse"] forState:UIControlStateNormal];
        [_exchangeButton addTarget:self action:@selector(exchangeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}

- (UIView *)translateBgView {
    if (!_translateBgView) {
        _translateBgView = [[UIView alloc] init];
        _translateBgView.backgroundColor = [UIColor whiteColor];
    }
    return _translateBgView;
}

- (UIButton *)translateButton {
    if (!_translateButton) {
        _translateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_translateButton setTitle:@"Translate" forState:UIControlStateNormal];
        [_translateButton setTitleColor:[UIColor TSP_colorWithHex:0xff282626] forState:UIControlStateNormal];
        [_translateButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_bg"] forState:UIControlStateNormal];
        _translateButton.layer.cornerRadius = TSPAdapterHeight(24);
        _translateButton.clipsToBounds = YES;
        [_translateButton addTarget:self action:@selector(translateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _translateButton;
}

- (TSPTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[TSPTextView alloc] init];
        _inputTextView.placeholder = @"Input text here";
        _inputTextView.placeholderColor = [UIColor TSP_colorWithHex:0xffBBBBBB];
        _inputTextView.placeholderFont = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _inputTextView.maxLength = 1000;
        _inputTextView.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _inputTextView.textColor = [UIColor TSP_colorWithHex:0xff6C6C6C];
        _inputTextView.showsVerticalScrollIndicator = NO;
        _inputTextView.showsHorizontalScrollIndicator = NO;
        _inputTextView.backgroundColor = [UIColor whiteColor];
    }
    return _inputTextView;
}

- (UIButton *)cleanTextButton {
    if (!_cleanTextButton) {
        _cleanTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanTextButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_close"] forState:UIControlStateNormal];
        _cleanTextButton.hidden = YES;
        [_cleanTextButton addTarget:self action:@selector(cleanTextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanTextButton;
}

- (UIView *)whiteBgView {
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

@end
