//
//  TSPCommonNavView.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPCommonNavView.h"

@interface TSPCommonNavView ()

@property (nonatomic, strong) UILabel * navTitleLabel;
@property (nonatomic, strong) UIButton * navBackButton;

@end

@implementation TSPCommonNavView

- (instancetype)initWithNavTitle:(NSString *)navTitle {
    self = [super init];
    if (self) {
        [self initializeAppearance];
        self.navTitleLabel.text = navTitle;
    }
    return self;
}

- (void)initializeAppearance {
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.navTitleLabel];
    [self addSubview:self.navBackButton];
    
    [self.navBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(TSPAdapterHeight(16));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(64));
        make.width.height.mas_equalTo(TSPAdapterHeight(16));
    }];
    
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(TSPAdapterHeight(21));
        make.centerY.mas_equalTo(self.navBackButton.mas_centerY);
    }];
}

- (void)backClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBackClick)]) {
        [self.delegate navBackClick];
    }
}

#pragma mark - Getter

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        _navTitleLabel.textColor = [UIColor whiteColor];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitleLabel;
}

- (UIButton *)navBackButton {
    if (!_navBackButton) {
        _navBackButton = [[UIButton alloc] init];
        [_navBackButton setBackgroundImage:[UIImage imageNamed:@"common_nav_back"] forState:UIControlStateNormal];
        [_navBackButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBackButton;
}

@end
