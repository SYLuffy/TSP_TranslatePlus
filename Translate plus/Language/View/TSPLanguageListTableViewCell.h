//
//  TSPLanguageListTableViewCell.h
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TSPLanguageModel;
@interface TSPLanguageListTableViewCell : UITableViewCell

@property (nonatomic, strong)TSPLanguageModel * model;

+ (NSString *)identifier;

- (void)loadLanguageModel:(TSPLanguageModel *)model;

@end

NS_ASSUME_NONNULL_END
