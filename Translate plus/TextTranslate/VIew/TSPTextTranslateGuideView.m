//
//  TSPTextTranslateGuideView.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPTextTranslateGuideView.h"

@interface TSPTextTranslateGuideView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * translateButton;
@property (nonatomic, strong) UIImageView * fingerImgView;

@end

@implementation TSPTextTranslateGuideView

+ (void)showGuideWithSuperView:(UIView *)superView {
    TSPTextTranslateGuideView * guideView = [[TSPTextTranslateGuideView alloc] initWithFrame:CGRectMake(0, 0, kTSPDeviceWidth, kTSPDeviceHeight)];
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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.titleLabel];
    [self addSubview:self.translateButton];
    [self addSubview:self.fingerImgView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(TSPAdapterHeight(-35));
        make.height.mas_equalTo(TSPAdapterHeight(20));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.translateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(TSPAdapterHeight(44));
        make.height.mas_equalTo(TSPAdapterHeight(48));
        make.width.mas_equalTo(TSPAdapterHeight(224));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.fingerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(86));
        make.top.mas_equalTo(self.translateButton.mas_top).offset(TSPAdapterHeight(15));
        make.right.mas_equalTo(self.translateButton.mas_right).offset(TSPAdapterHeight(28));
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _titleLabel.text = @"Tap the button to translate";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)translateButton {
    if (!_translateButton) {
        _translateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_translateButton setTitle:@"Translate" forState:UIControlStateNormal];
        [_translateButton setTitleColor:[UIColor TSP_colorWithHex:0xff282626] forState:UIControlStateNormal];
        [_translateButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_bg"] forState:UIControlStateNormal];
        _translateButton.layer.cornerRadius = TSPAdapterHeight(24);
        _translateButton.clipsToBounds = YES;
        [_translateButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _translateButton;
}

- (UIImageView *)fingerImgView {
    if (!_fingerImgView) {
        _fingerImgView = [[UIImageView alloc] init];
        _fingerImgView.image = [UIImage imageNamed:@"home_texttranslate_tap"];
    }
    return _fingerImgView;
}

@end
