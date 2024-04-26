//
//  TSPCommonButton.h
//  Translate plus
//
//  Created by shen on 2024/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPCommonAlignment) {
    TSPCommonAlignmentLeft,   ///居左
    TSPCommonAlignmentRight,  ///居右
    TSPCommonAlignmentCenter, ///居中
};

@interface TSPCommonButton : UIView

@property (nonatomic, copy)void(^tapClick)(void);

- (instancetype)initWithAlignment:(TSPCommonAlignment)alignment;

- (void)setImage:(UIImage *)image;

- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
