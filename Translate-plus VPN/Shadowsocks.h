//
//  Shadowsocks.h
//  LBFlashVPN
//
//  Created by shen on 2024/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ErrorCode) {
  noError = 0,
  undefinedError = 1,
  vpnPermissionNotGranted = 2,
  invalidServerCredentials = 3,
  udpRelayNotEnabled = 4,
  serverUnreachable = 5,
  vpnStartFailure = 6,
  illegalServerConfiguration = 7,
  shadowsocksStartFailure = 8,
  configureSystemProxyFailure = 9,
  noAdminPermissions = 10,
  unsupportedRoutingTable = 11,
  systemMisconfigured = 12
};

@interface Shadowsocks : NSObject

extern const int kShadowsocksLocalPort;

@property (nonatomic) NSDictionary *config;

/**
 * Initializes the object with a Shadowsocks server configuration, |config|.
 */
- (id)init:(NSDictionary *)config;

/**
 * Starts ss-local on a separate thread with the configuration supplied in the constructor.
 * If |checkConnectivity| is true, verifies that the server credentials are valid and that
 * the remote supports UDP forwarding, calling |completion| with the result.
 */
- (void)startWithConnectivityChecks:(bool)checkConnectivity
                         completion:(void (^)(ErrorCode))completion;

/**
 * Stops the thread running ss-local. Calls |completion| with the success of the operation.
 */
- (void)stop:(void (^)(ErrorCode))completion;

@end

NS_ASSUME_NONNULL_END
