//
//  TSPCommonNavView.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TSPCommonProtocol <NSObject>

@optional
- (void)navBackClick;

@end

@interface TSPCommonNavView : UIView
@property (nonatomic, weak)id <TSPCommonProtocol> delegate;

- (instancetype)initWithNavTitle:(NSString *)navTitle;

@end

NS_ASSUME_NONNULL_END
