//
//  TspStartUpView.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPStartupMode) {
    TSPStartupModeColdUp,
    TSPStartupModeFireUp,
};

@interface TSPStartUpView : UIView

+ (void)showStartUpMode:(TSPStartupMode)startUpMode superView:(nullable UIView *)superView;

@end

NS_ASSUME_NONNULL_END
