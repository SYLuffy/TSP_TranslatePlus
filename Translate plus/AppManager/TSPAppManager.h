//
//  TSPAppManager.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * kCameraPremissionedNoti = @"kCameraPremissionedNoti1";

@class TSPStartUpView,TSPTranslatingView, TSPVpnModel;
@interface TSPAppManager : NSObject

@property (nonatomic, weak)TSPStartUpView *startUpView;
@property (nonatomic, weak)TSPTranslatingView * translatingView;
@property (nonatomic, strong) NSMutableArray * vpnModelList;

/// vpn连接持续时间
@property (nonatomic, assign) NSInteger vpnKeepTime;
@property (nonatomic, assign) NSInteger lastVpnKeepTime;
@property (nonatomic, strong) TSPVpnModel * currentVpnModel;
@property (nonatomic, assign) BOOL isShowDisconnectedVC;

+ (instancetype)instance;

+ (void)isHasCameraAuthorityWithisShowAlert;

+ (void)isHasCameraAuthorityWithisShowAlert:(void(^)(BOOL isSuccess))comptionBlcok;

- (void)saveCurrentVpnInfo;

- (void)cleanCurrentVpnInfo;

- (void)startVpnKeepTime;

- (void)stopVpnKeepTime;

- (NSString *)formatTime:(NSInteger)totalSeconds;

@end

NS_ASSUME_NONNULL_END
