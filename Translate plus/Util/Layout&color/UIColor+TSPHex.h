//
//  UIColor+TSPHex.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (TSPHex)

/**
 *  十六进制颜色转换
 *
 *  @param hex 如：0xffb12524
 */
+ (UIColor *)TSP_colorWithHex:(uint)hex;

/**
 *  十六进制颜色转换
 *
 *  @param hex 如：0xffb125
 *  @param alpha 入：0.3
 */
+ (UIColor *)TSP_colorWithHex:(uint)hex andAlpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
