//
//  AppDelegate.m
//  Translate plus
//
//  Created by shen on 2024/4/17.
//

#import "AppDelegate.h"
#import "TSPHomeViewController.h"
#import "TSPStartUpView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[TSPVpnHelper shareInstance] load:nil];
    [TSPTranslateManager instance];
    [IQKeyboardManager sharedManager];
    TSPHomeViewController * homeVC = [[TSPHomeViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = homeVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [TSPStartUpView showStartUpMode:TSPStartupModeFireUp superView:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self userTraking];
}
- (void)userTraking {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch (status) {
                case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"用户拒绝");
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"用户允许");
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"用户未做选择");
                    break;
                default:
                    break;
            }
        }];
    }
}


@end
