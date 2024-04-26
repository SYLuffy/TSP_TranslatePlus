//
//  TSPAppManager.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPAppManager.h"
#import <AVFoundation/AVFoundation.h>
#import "TSPVpnModel.h"

static NSString * const kTSaveConnectedVpnName = @"kTSaveConnectedVpnName";

@interface TSPAppManager ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation TSPAppManager

+ (instancetype)instance {
    static TSPAppManager * tspM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tspM = [[TSPAppManager alloc] init];
        [tspM initData];
    });
    return tspM;
}

+ (void)isHasCameraAuthorityWithisShowAlert {
    [self isHasCameraAuthorityWithisShowAlert:nil];
}

+ (void)isHasCameraAuthorityWithisShowAlert:(void(^)(BOOL isSuccess))comptionBlcok {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        NSLog(@"[TSP] 没有访问相机的权限");
        [TSPAlertView showWithSuperView:nil alertType:TSPAlertTypeCamera];
        if (comptionBlcok) {
            comptionBlcok(NO);
        }
    }else if (status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCameraPremissionedNoti object:nil];
                NSLog(@"[TSP] 获取相机权限正常==============");
                if (comptionBlcok) {
                    comptionBlcok(YES);
                }
            }else{
                NSLog(@"[TSP] 获取相机权限不正常==============");
                if (comptionBlcok) {
                    comptionBlcok(NO);
                }
            }
        }];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCameraPremissionedNoti object:nil];
        NSLog(@"[TSP] 有访问相机的权限 =============");
        if (comptionBlcok) {
            comptionBlcok(YES);
        }
    }
}

- (void)initData {
    NSString * vpnTitle = [[NSUserDefaults standardUserDefaults] objectForKey:kTSaveConnectedVpnName];
    self.vpnModelList = [self getVpnConfigList];
    
    if (vpnTitle && vpnTitle.length > 0) {
        for (TSPVpnModel * model in self.vpnModelList) {
            if ([vpnTitle isEqualToString:model.titleName]) {
                self.currentVpnModel = model;
            }
        }
    }else {
        self.currentVpnModel = self.vpnModelList[0];
    }
}

- (void)saveCurrentVpnInfo {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentVpnModel.titleName forKey:kTSaveConnectedVpnName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanCurrentVpnInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTSaveConnectedVpnName];
}

- (NSMutableArray *)getVpnConfigList {
    ///,@"vpn_smart_Germany",@"vpn_smart_France",@"vpn_smart_Japan",@"vpn_smart_Australia",@"vpn_smart_Singapore"
    ///,@"Germany",@"France",@"Japan",@"Australia",@"Singapore"
    NSMutableArray * mArrays = [[NSMutableArray alloc] init];
    NSArray * iconNameArray = @[@"Smart Server",@"unitedstates",@"unitedstates"];
    NSArray * countryArray = @[@"Smart Server",@"Unite States",@"Unite States - 1"];
    NSArray * ipArrays = @[@"104.237.128.93",@"195.88.24.218",@"104.237.128.93"];
    for (int i = 0; i < iconNameArray.count; i ++) {
        NSString * imageName = iconNameArray[i];
        NSString * countryName = countryArray[i];
        TSPVpnModel * model = [[TSPVpnModel alloc] init];
        model.iconName = imageName;
        model.titleName = countryName;
        TSPVpnInfoModel * infoModel = [[TSPVpnInfoModel alloc] init];
        infoModel.serverIP = ipArrays[i];
        infoModel.serverPort = @"1543";
        infoModel.password = @"K49qpWT_sU8ML1+m";
        infoModel.method = @"chacha20-ietf-poly1305";
        model.vpnInfo = infoModel;
        [mArrays addObject:model];
    }
    return mArrays;
}

- (NSString *)formatTime:(NSInteger)totalSeconds {
    NSInteger hours = totalSeconds / 3600;
    NSInteger minutes = (totalSeconds % 3600) / 60;
    NSInteger seconds = totalSeconds % 60;

    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    
    return timeString;
}

- (void)startVpnKeepTime {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_WALLTIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self countDownTime];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)countDownTime {
    self.vpnKeepTime += 1;
}

- (void)stopVpnKeepTime {
    if (self.timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    self.lastVpnKeepTime = self.vpnKeepTime;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.vpnKeepTime = 0;
    });
}

@end
