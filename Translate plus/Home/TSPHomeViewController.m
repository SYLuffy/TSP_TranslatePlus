//
//  ViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/17.
//

#import "TSPHomeViewController.h"
#import "TSPStripEventView.h"
#import "TSPTextTranslateGuideView.h"
#import "TSPTextTranslateViewController.h"
#import "TSPOcrTranslateViewController.h"
#import "TSPVpnViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface TSPHomeViewController ()

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) UIImageView * titleImgView;
@property (nonatomic, strong) UIButton * textButton;
@property (nonatomic, strong) UIButton * ocrButton;
@property (nonatomic, strong) TSPStripEventView * vpnEventView;
@property (nonatomic, strong) TSPStripEventView * settingEventView;

@end

@implementation TSPHomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFirstLoad) {
        self.isFirstLoad = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.isFirstLoad = YES;
    [[TSPTranslateManager instance] downloadDefaultLanguageModel];
    [self initializeAppearance];
    [TSPStartUpView showStartUpMode:TSPStartupModeColdUp superView:self.view];
}

- (void)initializeAppearance {
    [self.view addSubview:self.titleImgView];
    [self.view addSubview:self.textButton];
    [self.view addSubview:self.ocrButton];
    [self.view addSubview:self.vpnEventView];
    [self.view addSubview:self.settingEventView];
    
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(TSPAdapterHeight(78));
        make.width.mas_equalTo(TSPAdapterHeight(221));
        make.height.mas_equalTo(TSPAdapterHeight(20));
    }];
    
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(TSPAdapterHeight(-8));
        make.width.mas_equalTo(TSPAdapterHeight(152));
        make.height.mas_equalTo(TSPAdapterHeight(184));
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(TSPAdapterHeight(26));
    }];
    
    [self.ocrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(TSPAdapterHeight(8));
        make.width.mas_equalTo(TSPAdapterHeight(152));
        make.height.mas_equalTo(TSPAdapterHeight(184));
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(TSPAdapterHeight(24));
    }];
    
    [self.vpnEventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TSPAdapterHeight(320));
        make.height.mas_equalTo(TSPAdapterHeight(68));
        make.top.mas_equalTo(self.ocrButton.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    [self.settingEventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TSPAdapterHeight(320));
        make.height.mas_equalTo(TSPAdapterHeight(68));
        make.top.mas_equalTo(self.vpnEventView.mas_bottom).offset(TSPAdapterHeight(16));
    }];
}

- (void)ocrClicked:(UIButton *)sender {
    TSPOcrTranslateViewController * ocrTransLateVc = [[TSPOcrTranslateViewController alloc] init];
    ocrTransLateVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ocrTransLateVc animated:YES completion:nil];
}

- (void)textClicked:(UIButton *)sender {
    TSPTextTranslateViewController * textTransLateVc = [[TSPTextTranslateViewController alloc] init];
    textTransLateVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:textTransLateVc animated:YES completion:nil];
}

#pragma mark - Getter

- (UIImageView *)titleImgView {
    if (!_titleImgView) {
        _titleImgView = [[UIImageView alloc] init];
        _titleImgView.image = [UIImage imageNamed:@"welcome_start_title"];
    }
    return _titleImgView;
}

- (UIButton *)ocrButton {
    if (!_ocrButton) {
        _ocrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocrButton setBackgroundImage:[UIImage imageNamed:@"home_translate_ocr"] forState:UIControlStateNormal];
        [_ocrButton addTarget:self action:@selector(ocrClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocrButton;
}

- (UIButton *)textButton {
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setBackgroundImage:[UIImage imageNamed:@"home_translate_text"] forState:UIControlStateNormal];
        [_textButton addTarget:self action:@selector(textClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

- (TSPStripEventView *)vpnEventView {
    if (!_vpnEventView) {
        _vpnEventView = [[TSPStripEventView alloc] initWithStripType:TSPStripTypeVpn];
    }
    return _vpnEventView;
}

- (TSPStripEventView *)settingEventView {
    if (!_settingEventView) {
        _settingEventView = [[TSPStripEventView alloc] initWithStripType:TSPStripTypeSetting];
    }
    return _settingEventView;
}

@end
