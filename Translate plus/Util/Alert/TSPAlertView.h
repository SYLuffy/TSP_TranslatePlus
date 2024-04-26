//
//  TSPPermissionCameraAlertView.h
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPAlertType) {
    TSPAlertTypeNetwork,
    TSPAlertTypeCamera,
};

@interface TSPAlertView : UIView

+ (void)showWithSuperView:(nullable UIView *)superView alertType:(TSPAlertType)alertType;

@end

NS_ASSUME_NONNULL_END
