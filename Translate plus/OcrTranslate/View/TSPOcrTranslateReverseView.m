//
//  TSPOcrTranslateReverseView.m
//  Translate plus
//
//  Created by shen on 2024/4/21.
//

#import "TSPOcrTranslateReverseView.h"

@interface TSPOcrTranslateReverseView ()

@property (nonatomic, strong) UIImageView * iconImgView;

@end

@implementation TSPOcrTranslateReverseView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.layer.cornerRadius = TSPAdapterHeight(8);
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(18));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - Getter

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"hoem_texttranslate_reverse"];
    }
    return _iconImgView;
}

@end
