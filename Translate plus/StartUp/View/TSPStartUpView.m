//
//  TspStartUpView.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPStartUpView.h"
#import "TSPVpnGuideView.h"
#import "TSPVpnViewController.h"
#import "TSPVpnResultViewController.h"

@interface TSPStartUpView ()

@property (nonatomic, assign) TSPStartupMode startupMode;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat animationNumber;

@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UIImageView * titleImgView;
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation TSPStartUpView

+ (void)showStartUpMode:(TSPStartupMode)startUpMode superView:(nullable UIView *)superView {
    TSPStartUpView * startUpView = [TSPAppManager instance].startUpView;
    if (!startUpView) {
        startUpView = [[TSPStartUpView alloc] initWithFrame:CGRectMake(0, 0, kTSPDeviceWidth, kTSPDeviceHeight) startUpMode:startUpMode];
        startUpView.tag = 1993;
        if (!superView) {
            [[UIApplication sharedApplication].windows.lastObject addSubview:startUpView];
        }else {
            [superView addSubview:startUpView];
        }
        [TSPAppManager instance].startUpView = startUpView;
    }
}

- (instancetype)initWithFrame:(CGRect)frame startUpMode:(TSPStartupMode)startUpMode {
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger animationTime = 3;
        if (startUpMode == TSPStartupModeColdUp) {
            ///冷启动 动画展示秒数随机
            animationTime = arc4random() % 3 + 1;
        }
        self.startupMode = startUpMode;
        self.animationNumber = 1.0/(animationTime/0.1);
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleImgView];
    [self addSubview:self.progressView];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(360));
        make.height.mas_equalTo(TSPAdapterHeight(389));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(96));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(TSPAdapterHeight(122));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(TSPAdapterHeight(254));
        make.height.mas_equalTo(TSPAdapterHeight(24));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(268));
        make.height.mas_equalTo(TSPAdapterHeight(4));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(TSPAdapterHeight(27));
    }];
    
    [self startTimer];
}

#pragma mark - Timer

- (void)startTimer {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self updateProgressValue];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)updateProgressValue {
    self.progress += self.animationNumber;
    self.progressView.progress = self.progress;
    if (self.progress >= 1.0) {
        self.progressView.progress = 1.0;
        [self stopTimer];
    }
}

-(void)stopTimer{
    if(self.timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [self stopLoading];
}

- (void)stopLoading {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0.0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (weakSelf.startupMode == TSPStartupModeColdUp) {
            /// 已连接情况下，不弹出引导，且获取当前连接的时间
            if ([TSPVpnHelper shareInstance].vpnState != TSPVpnHelperStateConnected) {
                [TSPVpnGuideView showGuideView:nil];
            } else {
                NSDate * connectedDate = [[TSPVpnHelper shareInstance] getCurrentConnectedTime];
                if (connectedDate) {
                    NSDate *currentDate = [NSDate date];
                    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:connectedDate];
                    NSInteger seconds = (NSInteger)timeInterval;
                    [TSPAppManager instance].vpnKeepTime = labs(seconds);
                    [[TSPAppManager instance] startVpnKeepTime];
                }
            }
        }else {
            if ([TSPVpnHelper shareInstance].vpnState != TSPVpnHelperStateConnected) {
                if ([TSPAppManager instance].isShowDisconnectedVC && ![[TSPTranslateManager instance] checkShowNetworkNotReachableToast]) {
                    [TSPAppManager instance].isShowDisconnectedVC = NO;
                    UIViewController * topVc = [self tsp_getCurrentUIVC];
                    if ([topVc isKindOfClass:[TSPVpnViewController class]]) {
                        [((TSPVpnViewController *)topVc) vpnDisconnected];
                        TSPVpnResultViewController * resultVC = [[TSPVpnResultViewController alloc] initWithResultType:TSPVpnResultTypeFailed];
                        resultVC.modalPresentationStyle = UIModalPresentationFullScreen;
                        [topVc presentViewController:resultVC animated:YES completion:nil];
                    }
            }
        }
    }
    }];
}

- (void)configProgressValue:(CGFloat)value {
    self.progressView.progress = value;
}

#pragma mark - Getter

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"welcome_start_icon"];
    }
    return _iconImgView;
}

- (UIImageView *)titleImgView {
    if (!_titleImgView) {
        _titleImgView = [[UIImageView alloc] init];
        _titleImgView.image = [UIImage imageNamed:@"welcome_start_title"];
    }
    return _titleImgView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0.0;
        _progressView.trackTintColor = [UIColor TSP_colorWithHex:0x808080];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.layer.cornerRadius = TSPAdapterHeight(3);
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}

@end
