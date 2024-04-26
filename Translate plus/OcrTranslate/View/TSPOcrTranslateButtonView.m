//
//  TSPOcrTranslateButtonView.m
//  Translate plus
//
//  Created by shen on 2024/4/21.
//

#import "TSPOcrTranslateButtonView.h"

@interface TSPOcrTranslateButtonView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * iconImagView;

@end

@implementation TSPOcrTranslateButtonView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tapGesture];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.layer.cornerRadius = TSPAdapterHeight(22);
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImagView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(TSPAdapterHeight(16));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(TSPAdapterHeight(-30));
        make.height.mas_equalTo(TSPAdapterHeight(18));
    }];
    [self.iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.mas_right).offset(TSPAdapterHeight(-14));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)tapClicked {
    if (self.tapClick) {
        self.tapClick();
    }
}


#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)iconImagView {
    if (!_iconImagView) {
        _iconImagView = [[UIImageView alloc] init];
        _iconImagView.image = [UIImage imageNamed:@"home_texttranslate_expend"];
    }
    return _iconImagView;
}

@end
