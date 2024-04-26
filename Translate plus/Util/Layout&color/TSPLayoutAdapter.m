//
//  TSPLayoutAdapter.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPLayoutAdapter.h"

@implementation TSPLayoutAdapter

+ (BOOL)checkPhoneNotchScreen {
    BOOL result = false;
    if (@available(iOS 11.0, *)) {
        result = [UIApplication sharedApplication].windows.lastObject.safeAreaInsets.bottom > 0?true:false;
    }
    return result;
}

+ (CGFloat)phoneAdapterWidthWithValue:(CGFloat)floatV {
    CGFloat width = kTSPRefereWidth;
    return  roundf(floatV*kTSPDeviceWidth/width);
}

+ (CGFloat)phoneAdapterHeightWithValue:(CGFloat)floatV {
    CGFloat height = kTSPReferHeight;
    return  roundf(floatV*kTSPDeviceHeight/height);
}

@end
