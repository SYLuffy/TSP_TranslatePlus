//
//  TSPCommonBaseViewController.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>
#import "TSPCommonNavView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSPCommonBaseViewController : UIViewController

@property (nonatomic, strong)TSPCommonNavView * navView;

///  子类重写
- (NSString *)navTitle;

/// 重写 即可改变退出按钮事件
- (void)handleBackClickEvent;

@end

NS_ASSUME_NONNULL_END
