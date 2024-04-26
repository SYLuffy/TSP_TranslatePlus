//
//  TSPLanguageListTableViewCell.m
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import "TSPLanguageListTableViewCell.h"
#import "TSPLanguageModel.h"

@interface TSPLanguageListTableViewCell ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * selectedImgView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation TSPLanguageListTableViewCell

+ (NSString *)identifier {
    return @"kTSPLanguageListTableViewCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    self.contentView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.selectedImgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.contentView.mas_right).offset(TSPAdapterHeight(-16));
        make.height.mas_equalTo(TSPAdapterHeight(56));
        make.top.mas_equalTo(self.mas_top).offset(TSPAdapterHeight(16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.bgView.mas_left).offset(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.selectedImgView.mas_left);
        make.height.mas_equalTo(TSPAdapterHeight(18));
    }];
    
    [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(TSPAdapterHeight(20));
        make.height.mas_equalTo(TSPAdapterHeight(15));
        make.right.mas_equalTo(self.bgView.mas_right).offset(TSPAdapterHeight(-16));
    }];
}

- (void)loadLanguageModel:(TSPLanguageModel *)model {
    self.model = model;
    self.titleLabel.text = model.language;
    self.selectedImgView.hidden = ![[TSPTranslateManager instance] checkCurrentSelected:model];
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(15)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)selectedImgView {
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] init];
        _selectedImgView.image = [UIImage imageNamed:@"home_lauange_tick"];
        _selectedImgView.hidden = YES;
    }
    return _selectedImgView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor TSP_colorWithHex:0xff383838];
    }
    return _bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
