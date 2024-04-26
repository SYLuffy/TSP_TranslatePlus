//
//  TSPVpnModel.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import <Foundation/Foundation.h>
#import "TSPVpnInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSPVpnModel : NSObject

@property (nonatomic, strong)NSString *iconName;
@property (nonatomic, strong)NSString *titleName;
@property (nonatomic, strong)TSPVpnInfoModel * vpnInfo;

- (NSDictionary<NSString *, NSObject *> *)objectConfig;

@end

NS_ASSUME_NONNULL_END
