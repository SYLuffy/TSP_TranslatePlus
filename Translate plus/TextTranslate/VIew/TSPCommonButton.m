//
//  TSPCommonButton.m
//  Translate plus
//
//  Created by shen on 2024/4/19.
//

#import "TSPCommonButton.h"

@interface TSPCommonButton ()

@property (nonatomic, assign)TSPCommonAlignment alignment;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UIImageView * iconImgView;

@end

@implementation TSPCommonButton

- (instancetype)initWithAlignment:(TSPCommonAlignment)alignment {
    self = [super init];
    if (self) {
        self.alignment = alignment;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tapGesture];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImgView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(TSPAdapterHeight(18));
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(16));
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(TSPAdapterHeight(14));
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image {
    
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
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(15)];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"home_texttranslate_expend"];
    }
    return _iconImgView;
}

@end
