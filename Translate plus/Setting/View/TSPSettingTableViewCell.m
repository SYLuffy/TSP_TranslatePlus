//
//  TSPSettingTableViewCell.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPSettingTableViewCell.h"
#import "TSPSettingModel.h"

@interface TSPSettingTableViewCell ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * rightArrowView;

@end

@implementation TSPSettingTableViewCell

+ (NSString *)identifier {
    return @"TSPSettingTableViewCell1";
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
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.rightArrowView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.contentView.mas_right).offset(TSPAdapterHeight(-16));
        make.height.mas_equalTo(TSPAdapterHeight(56));
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(24));
        make.left.mas_equalTo(self.bgView.mas_left).offset(TSPAdapterHeight(14));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TSPAdapterHeight(16));
        make.right.mas_equalTo(self.bgView.mas_right).offset(TSPAdapterHeight(-30));
        make.left.mas_equalTo(self.iconView.mas_right).offset(TSPAdapterHeight(12));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(TSPAdapterHeight(-16));
        make.width.height.mas_equalTo(TSPAdapterHeight(14));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
}

- (void)loadSettingModel:(TSPSettingModel *)model {
    self.model = model;
    self.iconView.image = [UIImage imageNamed:model.iconName];
    self.titleLabel.text = model.titleName;
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor TSP_colorWithHex:0xff383838];
    }
    return _bgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:TSPAdapterHeight(14)];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)rightArrowView {
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc] init];
        _rightArrowView.image = [UIImage imageNamed:@"home_setting_turn"];
    }
    return _rightArrowView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
