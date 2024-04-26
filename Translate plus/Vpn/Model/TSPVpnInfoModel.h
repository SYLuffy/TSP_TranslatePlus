//
//  TSPVpnInfoModel.h
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPVpnInfoModel : NSObject

@property (nonatomic, strong) NSString *serverIP;
@property (nonatomic, strong) NSString *serverPort;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *password;

@end

NS_ASSUME_NONNULL_END
