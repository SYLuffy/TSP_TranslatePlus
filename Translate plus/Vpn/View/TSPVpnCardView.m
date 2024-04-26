//
//  TSPVpnCommonView.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnCardView.h"
#import "TSPVpnServerListViewController.h"
#import "TSPVpnResultViewController.h"

@interface TSPVpnCardView () <CAAnimationDelegate>

@property (nonatomic, strong) UILabel * countTimeLabel;
@property (nonatomic, strong) dispatch_source_t  timer;
@property (nonatomic, strong) UIImageView * rocketImgView;
@property (nonatomic, assign) BOOL isReConnect;

///left card
@property (nonatomic, strong) UIView *cardBgView;
@property (nonatomic, strong) UIImageView * countryBgView;
@property (nonatomic, strong) UIImageView * countryIconView;
@property (nonatomic, strong) UILabel * changeServerLabel;
@property (nonatomic, strong) UIButton * changeServerButton;
@property (nonatomic, assign) CGFloat animationNumber;
@property (nonatomic, strong) UIButton * clickButton;

///right card
@property (nonatomic, strong) UIImageView * vpnStatusBgView;
@property (nonatomic, strong) UIView * vpnConnectedBgView;
@property (nonatomic, strong) UIImageView * normalImgView;
@property (nonatomic, strong) UIImageView * rotateImgView;
@property (nonatomic, strong) UILabel * normalLabel;
@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) UIButton * vpnStatusButton;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isProcessing;

@end

@implementation TSPVpnCardView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeVpnKeepTimeObserver];
}

- (instancetype)initWithVpnStatus:(TSPVpnStatus)status {
    self = [super init];
    if (self) {
        self.vpnStatus = status;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    [self addSubview:self.rocketImgView];
    [self addSubview:self.countTimeLabel];
    [self addSubview:self.cardBgView];
    [self addSubview:self.clickButton];
    [self.cardBgView addSubview:self.countryBgView];
    [self.cardBgView addSubview:self.countryIconView];
    [self.cardBgView addSubview:self.changeServerLabel];
    [self.cardBgView addSubview:self.changeServerButton];
    
    [self.cardBgView addSubview:self.vpnStatusBgView];
    [self.cardBgView addSubview:self.vpnConnectedBgView];
    [self.cardBgView addSubview:self.normalImgView];
    [self.cardBgView addSubview:self.rotateImgView];
    [self.cardBgView addSubview:self.normalLabel];
    [self.cardBgView addSubview:self.progressLabel];
    [self.cardBgView addSubview:self.vpnStatusButton];
    
    [self.countTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(28));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(TSPAdapterHeight(33));
    }];
    
    [self.rocketImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(296));
        make.height.mas_equalTo(TSPAdapterHeight(312));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.countTimeLabel.mas_bottom).offset(TSPAdapterHeight(6));
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.rocketImgView);
    }];
    
    [self.cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(296));
        make.height.mas_equalTo(TSPAdapterHeight(120));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.rocketImgView.mas_bottom).offset(TSPAdapterHeight(-25));
    }];
    
    [self.countryBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(44));
        make.left.mas_equalTo(self.cardBgView.mas_left).offset(TSPAdapterHeight(52));
        make.top.mas_equalTo(self.cardBgView.mas_top).offset(TSPAdapterHeight(21));
    }];
    
    [self.countryIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.countryBgView.mas_centerX);
        make.centerY.mas_equalTo(self.countryBgView.mas_centerY);
        make.width.height.mas_equalTo(TSPAdapterHeight(28));
    }];
    
    [self.changeServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cardBgView.mas_left);
        make.top.bottom.mas_equalTo(self.cardBgView);
        make.right.mas_equalTo(self.cardBgView.mas_centerX);
    }];
    
    [self.changeServerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cardBgView.mas_centerX);
        make.left.mas_equalTo(self.cardBgView.mas_left);
        make.height.mas_equalTo(TSPAdapterHeight(19));
        make.top.mas_equalTo(self.countryBgView.mas_bottom).offset(TSPAdapterHeight(15));
    }];
    
    [self.vpnStatusBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cardBgView.mas_centerX);
        make.right.mas_equalTo(self.cardBgView.mas_right);
        make.top.bottom.mas_equalTo(self.cardBgView);
    }];
    
    [self.vpnConnectedBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cardBgView.mas_centerX);
        make.right.mas_equalTo(self.cardBgView.mas_right);
        make.top.bottom.mas_equalTo(self.cardBgView);
    }];
    
    [self.normalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(44));
        make.top.mas_equalTo(self.cardBgView.mas_top).offset(TSPAdapterHeight(17));
        make.centerX.mas_equalTo(self.vpnStatusBgView.mas_centerX);
    }];
    
    [self.rotateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(44));
        make.top.mas_equalTo(self.cardBgView.mas_top).offset(TSPAdapterHeight(17));
        make.centerX.mas_equalTo(self.vpnStatusBgView.mas_centerX);
    }];
    
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TSPAdapterHeight(19));
        make.left.mas_equalTo(self.cardBgView.mas_centerX);
        make.right.mas_equalTo(self.cardBgView.mas_right);
        make.top.mas_equalTo(self.normalImgView.mas_bottom).offset(TSPAdapterHeight(18));
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TSPAdapterHeight(16));
        make.left.mas_equalTo(self.cardBgView.mas_centerX);
        make.right.mas_equalTo(self.cardBgView.mas_right);
        make.top.mas_equalTo(self.normalImgView.mas_bottom).offset(TSPAdapterHeight(21));
    }];
    
    [self.vpnStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.vpnStatusBgView);
    }];
    
    ///进度持续时间 固定 3秒
    self.animationNumber = 1.0/(3/0.1);
    [self updateUI:self.vpnStatus];
    [self addVpnKeepTimeObserver];
    [self addAppForwroundNotification];
}

- (void)changeServerAction {
    TSPVpnServerListViewController * vpnListVC = [[TSPVpnServerListViewController alloc] init];
    vpnListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self tsp_getCurrentUIVC] presentViewController:vpnListVC animated:YES completion:nil];
}

- (void)updateUI:(TSPVpnStatus)status {
    self.vpnStatus = status;
    switch (self.vpnStatus) {
        case TSPVpnStatusNormal:
            self.clickButton.enabled = YES;
            self.changeServerButton.enabled = YES;
            self.vpnStatusButton.enabled = YES;
            [self stopTimer];
            [self stopConnectAnimation];
            self.vpnStatusBgView.hidden = NO;
            self.vpnConnectedBgView.hidden = YES;
            self.rocketImgView.image = [UIImage imageNamed:@"vpn_rocket_normal"];
            self.countTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            self.normalImgView.image = [UIImage imageNamed:@"vpn_status_openbtn"];
            self.normalImgView.hidden = NO;
            self.normalLabel.hidden = NO;
            self.rotateImgView.hidden = YES;
            self.progressLabel.hidden = YES;
            break;
        case TSPVpnStatusConnecting:
            self.clickButton.enabled = NO;
            self.changeServerButton.enabled = NO;
            self.vpnStatusButton.enabled = NO;
            self.vpnStatusBgView.hidden = NO;
            self.vpnConnectedBgView.hidden = YES;
            self.rocketImgView.image = [UIImage imageNamed:@"vpn_rocket_normal"];
            self.countTimeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            self.normalImgView.hidden = YES;
            self.normalLabel.hidden = YES;
            self.rotateImgView.hidden = NO;
            self.progressLabel.hidden = NO;
            [self startTimer];
            [self startConnectAnimation];
            [self startVpnConnect];
            break;
        case TSPVpnStatusConnected:
            [[TSPAppManager instance] startVpnKeepTime];
            self.changeServerButton.enabled = YES;
            self.vpnStatusButton.enabled = YES;
            self.clickButton.enabled = YES;
            self.vpnStatusBgView.hidden = YES;
            self.vpnConnectedBgView.hidden = NO;
            [self stopConnectAnimation];
            self.rotateImgView.hidden = YES;
            self.normalImgView.hidden = NO;
            self.normalImgView.image = [UIImage imageNamed:@"vpn_status_tick"];
            self.countTimeLabel.textColor = [UIColor whiteColor];
            self.normalLabel.hidden = YES;
            self.rocketImgView.image = [UIImage imageNamed:@"vpn_status_connect"];
            self.progressLabel.text = @"Connected";
            break;
        case TSPVpnStatusDisconnecting:
            self.clickButton.enabled = NO;
            self.vpnStatusButton.enabled = NO;
            self.vpnStatusBgView.hidden = YES;
            self.vpnConnectedBgView.hidden = NO;
            self.rotateImgView.hidden = NO;
            self.normalImgView.hidden = YES;
            [self startTimer];
            [self startConnectAnimation];
            [[TSPVpnHelper shareInstance] stopVPN];
            break;
        case TSPVpnStatusDisconnected:
            
            break;
        default:
            break;
    }
}

- (void)jumpResultVc {
    TSPVpnResultType type = self.vpnStatus == TSPVpnStatusConnecting?TSPVpnResultTypeSuccessed:TSPVpnResultTypeFailed;
    TSPVpnResultViewController * result = [[TSPVpnResultViewController alloc] initWithResultType:type];
    result.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self tsp_getCurrentUIVC] presentViewController:result animated:YES completion:nil];
}

#pragma mark - proess 
- (void)addAppForwroundNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnectVpn) name:kReconnectionVpnNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)reconnectVpn {
    self.isReConnect = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickEvent];
    });
}

- (void)applicationDidEnterBackground {
    if (self.vpnStatus == TSPVpnStatusConnecting) {
        [[TSPVpnHelper shareInstance] stopVPN];
        [self updateUI:TSPVpnStatusNormal];
    }
}

- (void)addVpnKeepTimeObserver {
    [[TSPAppManager instance] addObserver:self forKeyPath:@"vpnKeepTime" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeVpnKeepTimeObserver {
    [[TSPAppManager instance] removeObserver:self forKeyPath:@"vpnKeepTime"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(TSPAppManager *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.countTimeLabel.text = [object formatTime:object.vpnKeepTime];
}

#pragma mark - Event
- (void)clickEvent {
    if (self.isProcessing) {
        return;
    }
    self.isProcessing = YES;
    if ([TSPVpnHelper shareInstance].managerState != TSPVpnManagerStateReady) {
        [[TSPVpnHelper shareInstance] createWithCompletionHandler:^(NSError * _Nonnull error) {
            if (!error) {
                if (![[TSPTranslateManager instance] checkShowNetworkNotReachableToast]) {
                    [self clickHandle];
                }else {
                    self.isProcessing = NO;
                }
                
            }else {
                [TSPToast showMessage:@"Try it agin." duration:3 finishHandler:nil];
                self.isProcessing = NO;
            }
        }];
    }else {
        if (![[TSPTranslateManager instance] checkShowNetworkNotReachableToast]) {
            [self clickHandle];
        }else {
            self.isProcessing = NO;
        }
    }
}

- (void)clickHandle {
    switch (self.vpnStatus) {
        case TSPVpnStatusNormal:
            [self updateUI:TSPVpnStatusConnecting];
            break;
        case TSPVpnStatusConnected:
            [self updateUI:TSPVpnStatusDisconnecting];
            break;
        default:
            break;
    }
    self.isProcessing = NO;
}

#pragma mark - Timer

- (void)startTimer {
    self.progress = 0.0f;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_WALLTIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self updateProgressValue];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)startVpnConnect {
    
  [[TSPVpnHelper shareInstance] connectWithServer:[TSPAppManager instance].currentVpnModel];
}

- (void)updateProgressValue {
    self.progress += self.animationNumber;
    if (self.progress >= 1.0f) {
        self.progress = 1.0f;
        [self stopTimer];
        if (self.vpnStatus == TSPVpnStatusConnecting) {
            self.progressLabel.text = @"Connected";
            /// 动画完成时，检查一下vpn的连接状态
            if ([TSPVpnHelper shareInstance].isActiveConnect && [TSPVpnHelper shareInstance].vpnState == TSPVpnHelperStateError) {
                [self updateUI:TSPVpnStatusNormal];
                [TSPToast showMessage:@"Try it agin." duration:2.8 finishHandler:nil];
                return;
            }
            [self jumpResultVc];
            [self updateUI:TSPVpnStatusConnected];
        }else {
            if (self.isReConnect) {
                self.isReConnect = NO;
                [self updateUI:TSPVpnStatusNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self clickEvent];
                });
            }else {
                [self jumpResultVc];
                [self updateUI:TSPVpnStatusNormal];
            }
        }
    }else {
        NSInteger number = self.progress * 100;
        if (self.vpnStatus == TSPVpnStatusConnecting) {
            self.progressLabel.text = [[NSString stringWithFormat:@"Connecting…%ld",(long)number] stringByAppendingString:@"%"];
        }else {
            self.progressLabel.text = [[NSString stringWithFormat:@"Disconnecting…%ld",(long)number] stringByAppendingString:@"%"];
        }
    }
}

-(void)stopTimer{
    if(self.timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)startConnectAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.delegate = self;
    
    [self.rotateImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopConnectAnimation {
    [self.rotateImgView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)updateStatus {
    self.countryIconView.image = [UIImage imageNamed:[TSPAppManager instance].currentVpnModel.iconName];
}

#pragma mark - Getter

- (UILabel *)countTimeLabel {
    if (!_countTimeLabel) {
        _countTimeLabel = [[UILabel alloc] init];
        _countTimeLabel.text = @"00:00:00";
        _countTimeLabel.font = [UIFont systemFontOfSize:28];
    }
    return _countTimeLabel;
}

- (UIImageView *)rocketImgView {
    if (!_rocketImgView) {
        _rocketImgView = [[UIImageView alloc] init];
    }
    return _rocketImgView;
}

- (UIView *)cardBgView {
    if (!_cardBgView) {
        _cardBgView = [[UIView alloc] init];
        _cardBgView.backgroundColor = [UIColor TSP_colorWithHex:0xff383838];
        _cardBgView.layer.cornerRadius = TSPAdapterHeight(25);
        _cardBgView.clipsToBounds = YES;
    }
    return _cardBgView;
}

- (UIImageView *)countryBgView {
    if (!_countryBgView) {
        _countryBgView = [[UIImageView alloc] init];
        _countryBgView.image = [UIImage imageNamed:@"vpn_country_location"];
    }
    return _countryBgView;
}

- (UIImageView *)countryIconView {
    if (!_countryIconView) {
        _countryIconView = [[UIImageView alloc] init];
    }
    return _countryIconView;
}

- (UILabel *)changeServerLabel {
    if (!_changeServerLabel) {
        _changeServerLabel = [[UILabel alloc] init];
        _changeServerLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _changeServerLabel.text = @"Change Servers";
        _changeServerLabel.textColor = [UIColor whiteColor];
        _changeServerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeServerLabel;
}

- (UIButton *)changeServerButton {
    if (!_changeServerButton) {
        _changeServerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeServerButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [_changeServerButton addTarget:self action:@selector(changeServerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeServerButton;
}

- (UIImageView *)vpnStatusBgView {
    if (!_vpnStatusBgView) {
        _vpnStatusBgView = [[UIImageView alloc] init];
        _vpnStatusBgView.image = [UIImage imageNamed:@"vpn_card_bg"];
        _vpnStatusBgView.layer.cornerRadius = TSPAdapterHeight(25);
        _vpnStatusBgView.clipsToBounds = YES;
    }
    return _vpnStatusBgView;
}

- (UIImageView *)normalImgView {
    if (!_normalImgView) {
        _normalImgView = [[UIImageView alloc] init];
    }
    return _normalImgView;
}

- (UIImageView *)rotateImgView {
    if (!_rotateImgView) {
        _rotateImgView = [[UIImageView alloc] init];
        _rotateImgView.image = [UIImage imageNamed:@"home_translate_loading"];
    }
    return _rotateImgView;
}

- (UILabel *)normalLabel {
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] init];
        _normalLabel.textColor = [UIColor TSP_colorWithHex:0xff282626];
        _normalLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _normalLabel.text = @"Tap to Connect";
        _normalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = [UIColor blackColor];
        _progressLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(14)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (UIButton *)vpnStatusButton {
    if (!_vpnStatusButton) {
        _vpnStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _vpnStatusButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [_vpnStatusButton addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vpnStatusButton;
}

- (UIView *)vpnConnectedBgView {
    if (!_vpnConnectedBgView) {
        _vpnConnectedBgView = [[UIView alloc] init];
        _vpnConnectedBgView.layer.cornerRadius = TSPAdapterHeight(25);
        _vpnConnectedBgView.clipsToBounds = YES;
        _vpnConnectedBgView.backgroundColor = [UIColor TSP_colorWithHex:0xffE2E2E2];
    }
    return _vpnConnectedBgView;
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
        [_clickButton addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}

@end
