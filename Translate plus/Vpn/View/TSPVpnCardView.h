//
//  TSPVpnCommonView.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPVpnStatus) {
    TSPVpnStatusNormal,
    TSPVpnStatusConnecting,
    TSPVpnStatusConnected,
    TSPVpnStatusDisconnecting,
    TSPVpnStatusDisconnected,
};

@interface TSPVpnCardView : UIView

@property (nonatomic, assign) TSPVpnStatus vpnStatus;

- (instancetype)initWithVpnStatus:(TSPVpnStatus)status;

- (void)updateUI:(TSPVpnStatus)status;

///直接开始连接
- (void)clickEvent;

- (void)updateStatus;

@end

NS_ASSUME_NONNULL_END
