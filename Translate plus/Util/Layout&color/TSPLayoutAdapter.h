//
//  TSPLayoutAdapter.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

///屏幕尺寸
#define kTSPIsIphoneX [TSPLayoutAdapter checkPhoneNotchScreen]

#define kTSPScreenWidth [UIScreen mainScreen].bounds.size.width
#define KTSPScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTSPDeviceWidth MIN(kTSPScreenWidth, KTSPScreenHeight)
#define kTSPDeviceHeight MAX(kTSPScreenWidth, KTSPScreenHeight)

///以IphoneX尺寸基准
#define kTSPRefereWidth 375.f
#define kTSPReferHeight 812.f

///非iPhoneX尺寸
#define kTSPPlusRefereWidth 360.f
#define kTSPPlusRefereHeight 640.f

#define TSPAdapterWidth(floatV) [TSPLayoutAdapter phoneAdapterWidthWithValue:floatV]
#define TSPAdapterHeight(floatV) [TSPLayoutAdapter phoneAdapterHeightWithValue:floatV]

NS_ASSUME_NONNULL_BEGIN

@interface TSPLayoutAdapter : NSObject

///判断是否是留海屏
+ (BOOL)checkPhoneNotchScreen;

///以屏幕宽（高）度为固定比例关系，计算不同屏幕下的值
+ (CGFloat)phoneAdapterWidthWithValue:(CGFloat)floatV;
+ (CGFloat)phoneAdapterHeightWithValue:(CGFloat)floatV;

@end

NS_ASSUME_NONNULL_END
