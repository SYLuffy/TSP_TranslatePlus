//
//  TSPVpnServerListTableViewCell.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPVpnServerListTableViewCell : UITableViewCell

@property (nonatomic, strong)TSPVpnModel * model;

+ (NSString *)identifier;

- (void)loadServerModel:(TSPVpnModel *)model;

@end

NS_ASSUME_NONNULL_END
