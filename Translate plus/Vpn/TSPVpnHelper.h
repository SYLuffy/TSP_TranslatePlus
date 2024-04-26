//
//  TSPVpnHelper.h
//  Translate plus
//
//  Created by shen on 2024/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPVpnManagerState) {
    TSPVpnManagerStateLoading,
    TSPVpnManagerStateIdle,
    TSPVpnManagerStatePreparing,
    TSPVpnManagerStateReady,
    TSPVpnManagerStateError
};

typedef NS_ENUM(NSUInteger, TSPVpnHelperState) {
    TSPVpnHelperStateIdle,
    TSPVpnHelperStateConnecting,
    TSPVpnHelperStateConnected,
    TSPVpnHelperStateDisconnecting,
    TSPVpnHelperStateDisconneced,
    TSPVpnHelperStateError,
};

@interface TSPVpnHelper : NSObject

@property (nonatomic, assign) BOOL connectedEver;
@property (nonatomic, assign) BOOL needConnectAfterLoaded;
@property (nonatomic, strong) TSPVpnModel * currentConnectingVpnModel;
@property (nonatomic, strong) TSPVpnModel * currentConnectedVpnModel;
@property (nonatomic, assign) TSPVpnManagerState managerState;
@property (nonatomic, assign) TSPVpnHelperState vpnState;
@property (nonatomic, assign) BOOL isActiveConnect;
@property (nonatomic, assign) BOOL isActiveDisConnect;

+ (instancetype)shareInstance;

- (NSDate *)getCurrentConnectedTime;

///创建Manager（vpn配置授权）
- (void)createWithCompletionHandler:(void (^)(NSError *error))completionHandler;

///加载Manager配置（已授权情况下）
- (void)load:(nullable void (^)(NSError *error))completionHandler;

///主动触发Vpn连接
-(void)connectWithServer:(TSPVpnModel * _Nullable)model;

///主动触发Vpn连接
- (void)stopVPN;

@end

NS_ASSUME_NONNULL_END
