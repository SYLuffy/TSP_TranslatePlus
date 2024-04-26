//
//  TSPTextTranslateResultViewViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/19.
//

#import "TSPTextTranslateResultViewViewController.h"
#import "TSPTextView.h"

@interface TSPTextTranslateResultViewViewController ()

@property (nonatomic, strong) UIButton * sourceButton;
@property (nonatomic, strong) UIButton * targetButton;
@property (nonatomic, strong) TSPTextView * sourceTextView;
@property (nonatomic, strong) TSPTextView * targetTextView;
@property (nonatomic, strong) UIView * hengxianView;

@end

@implementation TSPTextTranslateResultViewViewController

- (NSString *)navTitle {
    return @"Text Translate";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeAppearance];
}

- (void)initializeAppearance {
    [self.view addSubview:self.sourceButton];
    [self.view addSubview:self.targetButton];
    [self.view addSubview:self.hengxianView];
    [self.view addSubview:self.sourceTextView];
    [self.view addSubview:self.targetTextView];
    
    [self.sourceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(15));
        make.left.mas_equalTo(self.view.mas_left).offset(TSPAdapterHeight(15));
        make.width.mas_equalTo(TSPAdapterHeight(102));
        make.height.mas_equalTo(TSPAdapterHeight(38));
    }];
    
    [self.sourceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sourceButton.mas_bottom).offset(TSPAdapterHeight(9));
        make.left.mas_equalTo(self.view.mas_left).offset(TSPAdapterHeight(15));
        make.right.mas_equalTo(self.view.mas_right).offset(TSPAdapterHeight(-13));
        make.height.mas_equalTo(TSPAdapterHeight(132));
    }];
    
    [self.hengxianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.sourceTextView);
        make.top.mas_equalTo(self.sourceTextView.mas_bottom).offset(TSPAdapterHeight(24));
        make.height.mas_equalTo(TSPAdapterHeight(1));
    }];
    
    [self.targetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hengxianView.mas_bottom).offset(TSPAdapterHeight(28));
        make.left.mas_equalTo(self.view.mas_left).offset(TSPAdapterHeight(15));
        make.width.mas_equalTo(TSPAdapterHeight(102));
        make.height.mas_equalTo(TSPAdapterHeight(38));
    }];
    
    [self.targetTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.targetButton.mas_bottom).offset(TSPAdapterHeight(9));
        make.left.mas_equalTo(self.view.mas_left).offset(TSPAdapterHeight(15));
        make.right.mas_equalTo(self.view.mas_right).offset(TSPAdapterHeight(-13));
        make.height.mas_equalTo(TSPAdapterHeight(132));
    }];
}

- (void)setSourceString:(NSString *)sourceString resultString:(NSString *)resultString {
    TSPLanguageModel * sourceModel = [TSPTranslateManager instance].textSourceLanguage;
    TSPLanguageModel * targetModel = [TSPTranslateManager instance].textTargetLanguage;
    if ([TSPTranslateManager instance].isOcr) {
        sourceModel = [TSPTranslateManager instance].ocrSourceLanguage;
        targetModel = [TSPTranslateManager instance].ocrTargetLanguage;
    }
    [self.sourceButton setTitle:sourceModel.language forState:UIControlStateNormal];
    [self.targetButton setTitle:targetModel.language forState:UIControlStateNormal];
    self.sourceTextView.text = sourceString;
    self.targetTextView.text = resultString;
}

#pragma mark - Getter
- (UIButton *)sourceButton {
    if (!_sourceButton) {
        _sourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sourceButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        [_sourceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sourceButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_resultbg"] forState:UIControlStateNormal];
    }
    return _sourceButton;
}

- (TSPTextView *)sourceTextView {
    if (!_sourceTextView) {
        _sourceTextView = [[TSPTextView alloc] init];
        _sourceTextView.editable = NO;
        _sourceTextView.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _sourceTextView.showsVerticalScrollIndicator = NO;
        _sourceTextView.textColor = [UIColor TSP_colorWithHex:0xff6C6C6C];
        _sourceTextView.backgroundColor = [UIColor whiteColor];
    }
    return _sourceTextView;
}

- (TSPTextView *)targetTextView {
    if (!_targetTextView) {
        _targetTextView = [[TSPTextView alloc] init];
        _targetTextView.editable = NO;
        _targetTextView.font = [UIFont systemFontOfSize:TSPAdapterHeight(16)];
        _targetTextView.showsVerticalScrollIndicator = NO;
        _targetTextView.textColor = [UIColor TSP_colorWithHex:0xff6C6C6C];
        _targetTextView.backgroundColor = [UIColor whiteColor];
    }
    return _targetTextView;
}

- (UIButton *)targetButton {
    if (!_targetButton) {
        _targetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _targetButton.titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(18)];
        [_targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_targetButton setBackgroundImage:[UIImage imageNamed:@"home_texttranslate_resultbg"] forState:UIControlStateNormal];
    }
    return _targetButton;
}

- (UIView *)hengxianView {
    if (!_hengxianView) {
        _hengxianView = [[UIView alloc] init];
        _hengxianView.backgroundColor = [UIColor TSP_colorWithHex:0xffBBBBBB];
    }
    return _hengxianView;
}

@end
