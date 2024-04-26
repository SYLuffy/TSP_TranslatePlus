//
//  TSPTranslatingView.m
//  Translate plus
//
//  Created by shen on 2024/4/23.
//

#import "TSPTranslatingView.h"

@interface TSPTranslatingView () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView * loadingView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, assign) NSInteger loadingNumber;

@end

@implementation TSPTranslatingView

+ (void)showTranslatingWithSuperView:(UIView *)superView delegate:(nonnull id<TSPTranslatingProtocol>)delegate{
    TSPTranslatingView * loadingView = [[TSPTranslatingView alloc] initWithFrame:CGRectMake(0, 0, kTSPDeviceWidth, kTSPDeviceHeight)];
    loadingView.delegate = delegate;
    if (superView) {
        [superView addSubview:loadingView];
    }else {
        [[UIApplication sharedApplication].windows.lastObject addSubview:loadingView];
    }
    [TSPAppManager instance].translatingView = loadingView;
}

+ (void)stopTranslating {
    if ([TSPAppManager instance].translatingView) {
        [[TSPAppManager instance].translatingView stopTranslating];
        [[TSPAppManager instance].translatingView removeFromSuperview];
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
    self.loadingNumber = arc4random() % 15 + 3;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.loadingView];
    [self.bgView addSubview:self.titleLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(160));
        make.height.mas_equalTo(TSPAdapterHeight(132));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(44));
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).offset(TSPAdapterHeight(24));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(TSPAdapterHeight(19));
        make.top.mas_equalTo(self.loadingView.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    [self startConnectAnimation];
}

- (void)startConnectAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = self.loadingNumber;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.delegate = self;
    
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)stopTranslating {
    [self.loadingView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadingFinish)]) {
            [self.delegate loadingFinish];
        }
    }else {
        [self startConnectAnimation];
    }
}

#pragma mark - Getter

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        _loadingView.image = [UIImage imageNamed:@"home_translate_loading"];
    }
    return _loadingView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _titleLabel.text = @"Translating...";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.layer.cornerRadius = TSPAdapterHeight(8);
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

@end
