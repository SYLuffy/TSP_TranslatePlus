//
//  TSPSettingModel.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TSPSettingType) {
    TSPSettingTypeShare = 0,
    TSPSettingTypeTerms,
    TSPSettingTypePrivacy,
    TSPSettingTypeRateUs,
};

@interface TSPSettingModel : NSObject

@property (nonatomic, assign) TSPSettingType settingType;
@property (nonatomic, strong) NSString * iconName;
@property (nonatomic, strong) NSString * titleName;

@end

NS_ASSUME_NONNULL_END
