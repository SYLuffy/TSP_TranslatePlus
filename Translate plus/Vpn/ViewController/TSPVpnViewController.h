//
//  TSPVpnViewController.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPCommonBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSPVpnViewController : TSPCommonBaseViewController

- (instancetype)initWithNeedStartConnect:(BOOL)isStartConnect;

- (void)vpnDisconnected;

@end

NS_ASSUME_NONNULL_END
