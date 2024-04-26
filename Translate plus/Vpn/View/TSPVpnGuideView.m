//
//  TSPVpnGuideView.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnGuideView.h"
#import "TSPVpnViewController.h"

@interface TSPVpnGuideView ()

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UIImageView * titleView;
@property (nonatomic, strong) UIButton * okButton;
@property (nonatomic, strong) UIButton * skipButton;
@property (nonatomic, assign) NSInteger countTime;

@end

@implementation TSPVpnGuideView

+ (void)showGuideView:(UIView *)superView {
    TSPVpnGuideView * guideView = [[TSPVpnGuideView alloc] initWithFrame:CGRectMake(0, 0, kTSPDeviceWidth, kTSPDeviceHeight)];
    if (superView) {
        [superView addSubview:guideView];
    }else {
        [[UIApplication sharedApplication].windows.lastObject addSubview:guideView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.countTime = 5;
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.iconView];
    [self addSubview:self.titleView];
    [self addSubview:self.skipButton];
    [self addSubview:self.okButton];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(TSPAdapterHeight(280));
        make.height.mas_equalTo(TSPAdapterHeight(218));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(180));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(240));
        make.height.mas_equalTo(TSPAdapterHeight(24));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(TSPAdapterHeight(61));
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(248));
        make.height.mas_equalTo(TSPAdapterHeight(56));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(TSPAdapterHeight(61));
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(70));
        make.height.mas_equalTo(TSPAdapterHeight(19));
        make.right.mas_equalTo(self.mas_right).offset(TSPAdapterHeight(-24));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(49));
    }];
    
    
    [self countDownText];
}

- (void)okClick {
    TSPVpnViewController * vpnVC = [[TSPVpnViewController alloc] initWithNeedStartConnect:YES];
    vpnVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self tsp_getCurrentUIVC] presentViewController:vpnVC animated:YES completion:nil];
    [self dismiss];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)countDownText {
    if (self.countTime <= 0) {
        self.skipButton.enabled = YES;
        [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        return;
    }
    NSString * timeText = [[NSString stringWithFormat:@"Skip(%ld",(long)self.countTime] stringByAppendingString:@"s)"];
    [self.skipButton setTitle:timeText forState:UIControlStateNormal];
    self.countTime --;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countDownText];
    });
}

#pragma mark - Getter

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"vpn_guide_icon"];
    }
    return _iconView;
}

- (UIImageView *)titleView {
    if (!_titleView) {
        _titleView = [[UIImageView alloc] init];
        _titleView.image = [UIImage imageNamed:@"vpn_guide_titlte"];
    }
    return _titleView;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_bg"] forState:UIControlStateNormal];
        [_okButton setTitle:@"OK" forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        [_okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _okButton.layer.cornerRadius = TSPAdapterHeight(TSPAdapterHeight(28));
        _okButton.clipsToBounds = YES;
        [_okButton addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _skipButton.backgroundColor = [UIColor blackColor];
        [_skipButton setTitleColor:[UIColor TSP_colorWithHex:0xffFFFFFF] forState:UIControlStateNormal];
        [_skipButton setTitleColor:[[UIColor TSP_colorWithHex:0xffFFFFFF] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        [_skipButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.enabled = NO;
    }
    return _skipButton;
}

@end
