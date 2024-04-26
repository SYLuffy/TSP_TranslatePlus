//
//  TSPPermissionCameraAlertView.m
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import "TSPAlertView.h"

@interface TSPAlertView ()

@property (nonatomic, assign)TSPAlertType alertType;

@property (nonatomic, strong) UIView * boxView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * openNowButton;

@end

@implementation TSPAlertView

+ (void)showWithSuperView:(nullable UIView *)superView alertType:(TSPAlertType)alertType {
    TSPAlertView * alertVM = [[TSPAlertView alloc] initWithAlertType:alertType];
    alertVM.frame = CGRectMake(0, 0, kTSPDeviceWidth, kTSPDeviceHeight);
    if (!superView) {
        [[UIApplication sharedApplication].windows.lastObject addSubview:alertVM];
    }else {
        [superView addSubview:alertVM];
    }
}

- (instancetype)initWithAlertType:(TSPAlertType)alertType {
    self = [super init];
    if (self) {
        self.alertType = alertType;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.descLabel];
    [self.boxView addSubview:self.cancelButton];
    [self.boxView addSubview:self.openNowButton];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(276));
        make.height.mas_equalTo(TSPAdapterHeight(185));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.boxView.mas_centerX);
        make.top.mas_equalTo(self.boxView.mas_top).offset(TSPAdapterHeight(20));
        make.height.mas_equalTo(TSPAdapterHeight(21));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.boxView.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(TSPAdapterHeight(20));
        make.height.mas_equalTo(TSPAdapterHeight(44));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.boxView.mas_centerX).offset(TSPAdapterHeight(-6));
        make.width.mas_equalTo(TSPAdapterHeight(112));
        make.height.mas_equalTo(TSPAdapterHeight(44));
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(TSPAdapterHeight(18));
    }];
    
    [self.openNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(112));
        make.height.mas_equalTo(TSPAdapterHeight(44));
        make.left.mas_equalTo(self.boxView.mas_centerX).offset(TSPAdapterHeight(6));
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(TSPAdapterHeight(18));
    }];
    
    [self configType];
}

- (void)configType {
    NSString * title = @"Keep Network Safe";
    NSString * desc = @"Use VPN to improve the security\n level of your network.";
    if (self.alertType == TSPAlertTypeCamera) {
        title = @"Access Camera Permission";
        desc = @"We need camera permissions \nto recognize text.";
        [self.cancelButton setTitle:@"Refuse" forState:UIControlStateNormal];
        [self.openNowButton setTitle:@"Allow" forState:UIControlStateNormal];
    }
    self.titleLabel.text = title;
    self.descLabel.text = desc;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)openNowClick {
    if (self.alertType == TSPAlertTypeCamera) {
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]){
            [self dismiss];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }else {
        
    }
}

#pragma mark - Getter

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.layer.cornerRadius = TSPAdapterHeight(20);
        _boxView.clipsToBounds = YES;
        _boxView.backgroundColor = [UIColor whiteColor];
    }
    return _boxView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        _descLabel.textColor = [UIColor TSP_colorWithHex:0xff848484];
        _descLabel.numberOfLines = 2;
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(14)];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor TSP_colorWithHex:0xffD4D4D4]];
        _cancelButton.layer.cornerRadius = TSPAdapterHeight(TSPAdapterHeight(22));
        _cancelButton.clipsToBounds = YES;
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)openNowButton {
    if (!_openNowButton) {
        _openNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openNowButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_bg"] forState:UIControlStateNormal];
        [_openNowButton setTitle:@"Open Now" forState:UIControlStateNormal];
        _openNowButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        [_openNowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _openNowButton.layer.cornerRadius = TSPAdapterHeight(TSPAdapterHeight(22));
        _openNowButton.clipsToBounds = YES;
        [_openNowButton addTarget:self action:@selector(openNowClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openNowButton;
}

@end
