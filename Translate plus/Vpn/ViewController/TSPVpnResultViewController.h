//
//  TSPVpnResultViewController.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPCommonBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPVpnResultType) {
    TSPVpnResultTypeSuccessed,
    TSPVpnResultTypeFailed,
};


@interface TSPVpnResultViewController : TSPCommonBaseViewController

- (instancetype)initWithResultType:(TSPVpnResultType)resultType;
@end

NS_ASSUME_NONNULL_END
