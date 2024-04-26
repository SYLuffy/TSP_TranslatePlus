//
//  TSPVpnHelper.m
//  Translate plus
//
//  Created by shen on 2024/4/25.
//

#import "TSPVpnHelper.h"
#import <NetworkExtension/NetworkExtension.h>

@interface TSPVpnHelper()

@property (nonatomic, strong) NETunnelProviderManager * manager;

@end

@implementation TSPVpnHelper

+ (instancetype)shareInstance {
    static TSPVpnHelper * vpnHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vpnHelper = [[TSPVpnHelper alloc] init];
    });
    return vpnHelper;
}

#pragma mark - Vpn connect

- (void)connectWithServer:(TSPVpnModel *)model {
    self.currentConnectingVpnModel = model;
    self.isActiveConnect = YES;
    NSString * logInfo = [NSString stringWithFormat:@"记录当前正在连接的vpn：name:%@,ip:%@", self.currentConnectingVpnModel.iconName, self.currentConnectingVpnModel.vpnInfo.serverIP];
    NSLog(@"%@",logInfo);
    if (!self.manager) {
        NSLog(@"[VPN MANAGER] manager is nil, cannot connect");
        self.vpnState = TSPVpnHelperStateError;
        return;
    }
    
    if (!self.manager.isEnabled) {
        NSLog(@"[VPN MANAGER] manager is not enabled");
        self.needConnectAfterLoaded = YES;
        
        __weak typeof(self) weakSelf = self;
        [self.manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error) {
                NSString * loginInfo = [NSString stringWithFormat:@"[VPN MANAGER] cannot enable mananger: %@", error.localizedDescription];
                NSLog(@"%@",logInfo);
                strongSelf.managerState = TSPVpnManagerStateError;
            } else {
                [strongSelf.manager setEnabled:YES];
                [strongSelf.manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSString * logInfo = [NSString stringWithFormat:@"[VPN MANAGER] cannot save manager into preferences: %@", error.localizedDescription];
                        NSLog(@"%@",logInfo);
                        strongSelf.managerState = TSPVpnManagerStateError;
                    } else {
                        [self startVPNTunnelWithServer:model];
                    }
                }];
            }
        }];
    } else {
        [self startVPNTunnelWithServer:model];
    }
}

- (void)stopVPN {
    self.isActiveDisConnect = YES;
    NEVPNConnection *connection = self.manager.connection;
    if (connection && connection.status != NEVPNStatusDisconnected) {
        NSString * logInfo = [NSString stringWithFormat:@"记录当前正在断开的vpn：name:%@,ip:%@", self.currentConnectedVpnModel.iconName, self.currentConnectedVpnModel.vpnInfo.serverIP];
        NSLog(@"%@",logInfo);
        [connection stopVPNTunnel];
    }
}

- (void)startVPNTunnelWithServer:(TSPVpnModel * _Nullable)model {
    if (!self.manager) {
        NSLog(@"[VPN MANAGER] manager is nil, cannot connect");
        return;
    }
    
    NSError *error = nil;
    [self.manager.connection startVPNTunnelWithOptions:[model objectConfig] andReturnError:&error];
    if (error) {
        NSString * logInfo = [NSString stringWithFormat:@"[VPN MANAGER] Start VPN failed %@", error.localizedDescription];
        NSLog(@"%@",logInfo);
        self.vpnState = TSPVpnHelperStateError;
    } else {
        self.connectedEver = YES;
        self.currentConnectedVpnModel = self.currentConnectingVpnModel;
        self.vpnState = TSPVpnHelperStateConnected;
    }
}

- (NSDate *)getCurrentConnectedTime {
    if (self.vpnState == TSPVpnHelperStateConnected) {
        return self.manager.connection.connectedDate;
    }
    return nil;
}

#pragma mark - vpnManager

- (void)createWithCompletionHandler:(void (^)(NSError *error))completionHandler {
    NETunnelProviderManager *manager = [[NETunnelProviderManager alloc] init];
    [manager setEnabled:YES];
    NETunnelProviderProtocol *p = [[NETunnelProviderProtocol alloc] init];
    p.serverAddress = @"VPNTest";
    p.providerBundleIdentifier = @"dev.shenyi.com.Translateplus.proxy";
    p.providerConfiguration = @{@"manager_version": @"manager_v1"};
    manager.protocolConfiguration = p;
    self.connectedEver = false;
    [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            self.managerState = TSPVpnManagerStateError;
            if (completionHandler != nil) {
                completionHandler(error);
            }
            return;
        }
        
        [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSString * codeInfo = [NSString stringWithFormat:@"[VPN MANAGER] code: %ld", (long)NEVPNErrorConfigurationReadWriteFailed];
                NSString * codeInfo1 = [NSString stringWithFormat:@"[VPN MANAGER] code: %ld", (long)NEVPNErrorConfigurationStale];
                NSString * errorInfo = [NSString stringWithFormat:@"[VPN MANAGER] create failed: %@", error.localizedDescription];
                self.managerState = TSPVpnManagerStateError;
                NSLog(@"%@",codeInfo);
                NSLog(@"%@",codeInfo1);
                NSLog(@"%@",errorInfo);
                if (completionHandler != nil) {
                    completionHandler(error);
                }
            } else {
                [self load:completionHandler];
            }
        }];
    }];
}

- (void)load:(void (^)(NSError *error))completionHandler {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error) {
            self.managerState = TSPVpnManagerStateError;
            self.connectedEver = false;
            NSLog(@"[VPN MANAGER] cannot load managers from preferences: %@", error.localizedDescription);
            if (completionHandler != nil) {
                completionHandler(error);
            }
            return;
        }
        
        if (managers.count == 0) {
            self.managerState = TSPVpnManagerStateIdle;
            self.connectedEver = false;
            NSLog(@"[VPN MANAGER] have no manager");
            NSError * error1 = [NSError errorWithDomain:@"[VPN MANAGER] have no manager" code:11000 userInfo:nil];
            if (completionHandler != nil) {
                completionHandler(error1);
            }
            return;
        }
        
        NETunnelProviderManager *manager = managers.firstObject;
        [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"[VPN MANAGER] cannot load manager from preferences: %@", error.localizedDescription);
                self.managerState = TSPVpnManagerStateError;
                if (completionHandler != nil) {
                    completionHandler(error);
                }
            }
            
            NSLog(@"[VPN MANAGER] manager loaded from preferences");
            self.manager = manager;
            self.managerState = TSPVpnManagerStateReady;
            [self addVPNStatusDidChangeObserver];
            [self updateVPNStatus];
            if (completionHandler != nil) {
                completionHandler(nil);
            }
        }];
    }];
}

- (void)prepareForLoadingWithCompletionHandler:(void (^)(void))completionHandler {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        int times = 20;
        while (times > 0) {
            times -= 1;
            if (self.managerState != TSPVpnManagerStateLoading) {
                [self makeSureRunInMainThread:^{
                    completionHandler();
                }];
                return;
            }
            [NSThread sleepForTimeInterval:0.2];
        }
        [self makeSureRunInMainThread:^{
            completionHandler();
        }];
    });
}

- (void)makeSureRunInMainThread:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}


#pragma mark - Vpn state

- (void)addVPNStatusDidChangeObserver {
    if (self.manager) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVPNStatus) name:NEVPNStatusDidChangeNotification object:nil];
    }
   
}

- (void)removeVPNStatusDidChangeObserver:(NSNotification *)notification {
    
}

- (void)updateVPNStatus {
    if (self.manager) {
        if ([self.manager.connection isKindOfClass:[NETunnelProviderSession class]]) {
            NETunnelProviderSession * session = (NETunnelProviderSession *)self.manager.connection;
//            if (!self.connectedEver && session.status != LBVpnStateDisconneced) {
//                NSString * logInfo = [NSString stringWithFormat:@"[VPN MANAGER] not connected yet, but status is (%ld)",(long)session.status];
//                LBDebugLog(logInfo);
//                return;
//            }
            switch (session.status) {
                case NEVPNStatusConnecting:
                    NSLog(@"NEVPNStatusConnecting");
                    self.vpnState = TSPVpnHelperStateConnecting;
                    break;
                case NEVPNStatusConnected:
                    NSLog(@"NEVPNStatusConnected");
                    self.vpnState = TSPVpnHelperStateConnected;
                    [[TSPAppManager instance] saveCurrentVpnInfo];
                    break;
                case NEVPNStatusDisconnecting:
                    NSLog(@"NEVPNStatusDisconnecting");
                    self.vpnState = TSPVpnHelperStateDisconnecting;
                    break;
                case NEVPNStatusDisconnected:
                    NSLog(@"NEVPNStatusDisconnected");
                    self.vpnState = TSPVpnHelperStateDisconneced;
                    if (self.isActiveDisConnect) {
                        self.isActiveDisConnect = NO;
                    }else {
                        [TSPAppManager instance].isShowDisconnectedVC = YES;
                    }
                    [[TSPAppManager instance] stopVpnKeepTime];
                    [[TSPAppManager instance] cleanCurrentVpnInfo];
                    break;
                case NEVPNStatusInvalid:
                    NSLog(@"NEVPNStatusInvalid");
                    self.vpnState = TSPVpnHelperStateError;
                    [TSPToast showMessage:@"Try it agin." duration:3 finishHandler:nil];
                    break;
                default:
                    break;
            }
        }
    }
  
}

@end
