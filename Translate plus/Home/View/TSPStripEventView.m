//
//  TSPStripEventView.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPStripEventView.h"
#import "TSPSettingViewController.h"
#import "TSPVpnViewController.h"

@interface TSPStripEventView ()

@property (nonatomic, strong) UIImageView * bgImgView;
@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * arrowImgView;

@property (nonatomic, assign) TSPStripType stripType;

@end

@implementation TSPStripEventView

- (instancetype)initWithStripType:(TSPStripType)stripType {
    self = [super init];
    if (self) {
        self.stripType = stripType;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    [self addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.iconImgView];
    [self.bgImgView addSubview:self.titleLabel];
    [self.bgImgView addSubview:self.arrowImgView];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent)];
    [self addGestureRecognizer:gesture];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgImgView.mas_centerY);
        make.left.mas_equalTo(self.bgImgView.mas_left).offset(TSPAdapterHeight(88));
        make.height.mas_equalTo(TSPAdapterHeight(25));
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(20));
        make.centerY.mas_equalTo(self.bgImgView.mas_centerY);
        make.right.mas_equalTo(self.bgImgView.mas_right).offset(TSPAdapterHeight(-20));
    }];
    
    if (self.stripType == TSPStripTypeVpn) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgImgView.mas_centerY);
            make.left.mas_equalTo(self.bgImgView.mas_left).offset(TSPAdapterHeight(11));
            make.width.height.mas_equalTo(TSPAdapterHeight(58));
        }];
        self.bgImgView.image = [UIImage imageNamed:@"home_strip_greenbg"];
        self.iconImgView.image = [UIImage imageNamed:@"home_strip_vpnicon"];
        self.titleLabel.text = @"VPN";
    }else {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgImgView.mas_centerY);
            make.left.mas_equalTo(self.bgImgView.mas_left).offset(TSPAdapterHeight(25));
            make.width.height.mas_equalTo(TSPAdapterHeight(32));
        }];
        self.bgImgView.image = [UIImage imageNamed:@"home_strip_bluebg"];
        self.iconImgView.image = [UIImage imageNamed:@"home_strip_settingicon"];
        self.titleLabel.text = @"Setting";
    }
}

- (void)clickEvent {
    if (self.stripType == TSPStripTypeSetting) {
        TSPSettingViewController * setVC = [[TSPSettingViewController alloc] init];
        setVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self tsp_getCurrentUIVC] presentViewController:setVC animated:YES completion:nil];
    }else {
        TSPVpnViewController * vpnVC = [[TSPVpnViewController alloc] init];
        vpnVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self tsp_getCurrentUIVC] presentViewController:vpnVC animated:YES completion:nil];
    }
}

#pragma mark - Getter

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
    }
    return _bgImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"home_strip_turnarrow"];
    }
    return _arrowImgView;
}

@end
