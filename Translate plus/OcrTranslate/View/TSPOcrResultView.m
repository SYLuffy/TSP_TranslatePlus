//
//  TSPOcrResultView.m
//  Translate plus
//
//  Created by shen on 2024/4/23.
//

#import "TSPOcrResultView.h"
#import "TSPTextView.h"

@interface TSPOcrResultView ()

@property (nonatomic, strong) TSPTextView * textView;
@property (nonatomic, strong) UIButton * tsCopyButton;
@property (nonatomic, strong) UIButton * retryButton;

@end

@implementation TSPOcrResultView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.textView];
    [self addSubview:self.tsCopyButton];
    [self addSubview:self.retryButton];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(268));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(74));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.tsCopyButton.mas_top).offset(TSPAdapterHeight(-10));
    }];
    
    [self.tsCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(TSPAdapterHeight(-22));
        make.width.height.mas_equalTo(TSPAdapterHeight(84));
        make.bottom.mas_equalTo(self.mas_bottom).offset(TSPAdapterHeight(-83));
    }];
    
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(TSPAdapterHeight(22));
        make.width.height.mas_equalTo(TSPAdapterHeight(84));
        make.bottom.mas_equalTo(self.mas_bottom).offset(TSPAdapterHeight(-83));
    }];
}

- (void)setTranslateText:(NSString *)translateText {
    self.textView.text = translateText;
}

- (void)copyClicked {
    if (self.resultCopyBlock) {
        self.resultCopyBlock();
    }
}

- (void)retryClicked {
    if (self.resultRetryBlock) {
        self.resultRetryBlock();
    }
}

#pragma mark - Getter

- (TSPTextView *)textView {
    if (!_textView) {
        _textView = [[TSPTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _textView.textColor = [UIColor whiteColor];
        _textView.editable = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    return _textView;
}

- (UIButton *)tsCopyButton {
    if (!_tsCopyButton) {
        _tsCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tsCopyButton setBackgroundImage:[UIImage imageNamed:@"home_ocrtranslate_copy"] forState:UIControlStateNormal];
        [_tsCopyButton addTarget:self action:@selector(copyClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tsCopyButton;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"home_ocrtranslate_retry"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

@end
