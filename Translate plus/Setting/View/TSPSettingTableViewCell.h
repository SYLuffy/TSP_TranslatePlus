//
//  TSPSettingTableViewCell.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TSPSettingModel;
@interface TSPSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) TSPSettingModel *model;

+ (NSString *)identifier;

- (void)loadSettingModel:(TSPSettingModel *)model;

@end

NS_ASSUME_NONNULL_END
