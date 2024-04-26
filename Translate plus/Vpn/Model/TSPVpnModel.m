//
//  TSPVpnModel.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnModel.h"

@implementation TSPVpnModel

- (NSDictionary<NSString *, NSObject *> *)objectConfig {
    NSString *host = self.vpnInfo.serverIP;
    NSString *port = self.vpnInfo.serverPort;
    NSString *method = self.vpnInfo.method;
    NSString *password = self.vpnInfo.password;
    
    NSDictionary<NSString *, NSObject *> *objectDictionary = @{@"host": host, @"port": port, @"method": method, @"password": password};
    return objectDictionary;
}

@end
