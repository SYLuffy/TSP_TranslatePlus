//
//  TSPLanguageManager.h
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPAppNetworkStatus) {
    TSPAppNetworkStatusUnknow = -1,          ///未知
    TSPAppNetworkStatusNotReachable = 0,     ///未联网
    TSPAppNetworkStatusReachable = 1,        ///联网
};
@interface TSPTranslateManager : NSObject

@property (nonatomic, assign) TSPAppNetworkStatus networkStatus;

@property (nonatomic, strong) NSMutableArray <TSPLanguageModel *>* allLanguageArrays;
@property (nonatomic, strong) TSPLanguageModel * textSourceLanguage;
@property (nonatomic, strong) TSPLanguageModel * textTargetLanguage;
@property (nonatomic, strong) TSPLanguageModel * ocrSourceLanguage;
@property (nonatomic, strong) TSPLanguageModel * ocrTargetLanguage;
@property (nonatomic, assign) BOOL isOcr;
@property (nonatomic, assign) BOOL isSource;
@property (nonatomic, copy) void(^completeBlcok)(BOOL isSucces, NSString * result);

+ (instancetype)instance;

- (void)downloadDefaultLanguageModel;

- (void)transLateModeDonwload:(NSString *)languageCode;

/// isSelected 是否被选中
- (BOOL)checkCurrentSelected:(TSPLanguageModel *)model;

- (BOOL)checkShowNetworkNotReachableToast;

- (void)updateLanguageModel:(TSPLanguageModel *)model;

/// 文字（真正）翻译
- (void)transLateWith:(NSString *)sourceString completeBlcok:(void(^)(BOOL isSucces, NSString * result))completeBlcok;

/// OCR翻译
- (void)ocrTransLateWith:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation completeBlcok:(void(^)(BOOL isSucces, NSString * result))completeBlcok;

- (void)exchangeLanguage:(BOOL)isOcr;

@end

NS_ASSUME_NONNULL_END
