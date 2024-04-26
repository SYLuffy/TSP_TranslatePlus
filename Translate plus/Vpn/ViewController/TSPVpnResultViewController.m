//
//  TSPVpnResultViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnResultViewController.h"
#import "TSPStripEventView.h"
#import "TSPOcrTranslateViewController.h"
#import "TSPTextTranslateViewController.h"

@interface TSPVpnResultViewController ()

@property (nonatomic, assign)TSPVpnResultType resultType;

@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UIImageView * titleImgView;
@property (nonatomic, strong) UIButton * textButton;
@property (nonatomic, strong) UIButton * ocrButton;

@end

@implementation TSPVpnResultViewController

- (NSString *)navTitle {
    return @"Result";
}

- (instancetype)initWithResultType:(TSPVpnResultType)resultType {
    self = [super init];
    if (self) {
        self.resultType = resultType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.titleImgView];
    [self.view addSubview:self.textButton];
    [self.view addSubview:self.ocrButton];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(22));
        make.width.mas_equalTo(TSPAdapterHeight(176));
        make.height.mas_equalTo(TSPAdapterHeight(192));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(TSPAdapterHeight(7));
        make.width.mas_equalTo(TSPAdapterHeight(183));
        make.height.mas_equalTo(TSPAdapterHeight(17));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(TSPAdapterHeight(-8));
        make.width.mas_equalTo(TSPAdapterHeight(152));
        make.height.mas_equalTo(TSPAdapterHeight(184));
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    [self.ocrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(TSPAdapterHeight(8));
        make.width.mas_equalTo(TSPAdapterHeight(152));
        make.height.mas_equalTo(TSPAdapterHeight(184));
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    if (self.resultType == TSPVpnResultTypeSuccessed) {
        self.iconImgView.image = [UIImage imageNamed:@"vpn_result_successed"];
        self.titleImgView.image = [UIImage imageNamed:@"vpn_result_now"];
    }else {
        self.iconImgView.image = [UIImage imageNamed:@"vpn_result_failed"];
        self.titleImgView.image = [UIImage imageNamed:@"vpn_result_disnow"];
    }
}

- (void)ocrClicked:(UIButton *)sender {
    TSPOcrTranslateViewController * ocrTransLateVc = [[TSPOcrTranslateViewController alloc] init];
    ocrTransLateVc.isFormVpnResult = YES;
    ocrTransLateVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ocrTransLateVc animated:YES completion:nil];
}

- (void)textClicked:(UIButton *)sender {
    TSPTextTranslateViewController * textTransLateVc = [[TSPTextTranslateViewController alloc] init];
    textTransLateVc.isFormVpnResult = YES;
    textTransLateVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:textTransLateVc animated:YES completion:nil];
}

#pragma mark - Getter

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UIImageView *)titleImgView {
    if (!_titleImgView) {
        _titleImgView = [[UIImageView alloc] init];
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

@end
