//
//  TSPLanguageManager.m
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import "TSPTranslateManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MLKitTranslate/MLKitTranslate.h>
#import <MLKitCommon/MLKitCommon.h>
#import <MLKitLanguageID/MLKitLanguageID.h>
#import <MLKitTextRecognition/MLKitTextRecognition.h>
#import <MLKitTextRecognitionChinese/MLKitTextRecognitionChinese.h>
#import <MLKitTextRecognitionKorean/MLKitTextRecognitionKorean.h>
#import <MLKitTextRecognitionJapanese/MLKitTextRecognitionJapanese.h>
#import <MLKitVision/MLKVisionImage.h>
#import <MLKitTextRecognitionCommon/MLKitTextRecognitionCommon.h>
#import <WebKit/WebKit.h>

static NSString * textSourceKey = @"textSourceKey";
static NSString * textTargetKey = @"textTargetKey";
static NSString * ocrSourceKey = @"ocrSourceKey";
static NSString * ocrTargetKey = @"ocrTargetKey";

@interface TSPTranslateManager() <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) NSString * sandboxFilePath;
@property (nonatomic, strong) NSMutableDictionary * languageModelDicts;

@end

@implementation TSPTranslateManager

+ (instancetype)instance {
    static TSPTranslateManager * languageM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        languageM = [[TSPTranslateManager alloc] init];
        [languageM initFilePath];
        [languageM loadAllLanguages];
        [languageM checkNetStatus];
    });
    return languageM;
}

- (void)initFilePath {
    self.sandboxFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Tsplanguage.archiver"];
    self.languageModelDicts = [NSKeyedUnarchiver unarchiveObjectWithFile:self.sandboxFilePath];
}

#pragma mark - Network

///网络检测
- (void)checkNetStatus {
    __weak typeof(self) weakSelf = self;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                strongSelf.networkStatus = TSPAppNetworkStatusUnknow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                strongSelf.networkStatus = TSPAppNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                strongSelf.networkStatus = TSPAppNetworkStatusReachable;
                break;
            default:
                break;
        }
    }];
}

- (BOOL)checkShowNetworkNotReachableToast {
    if (self.networkStatus != TSPAppNetworkStatusReachable) {
        [TSPToast showMessage:@"Internet seems to be missing." duration:3 finishHandler:nil];
        return YES;
    }
    return NO;
}

- (void)downloadDefaultLanguageModel {
    ///判断语言包是否已下载
    MLKTranslateRemoteModel * chineseRemoteModel = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:@"zh"];
    MLKTranslateRemoteModel * englishRemoteModel = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:@"en"];
    MLKTranslateRemoteModel * sqRemoteModel = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:@"sq"];
    
    BOOL isChinese = [[MLKModelManager modelManager] isModelDownloaded:chineseRemoteModel];
    BOOL isEnglish = [[MLKModelManager modelManager] isModelDownloaded:englishRemoteModel];
    BOOL isSq = [[MLKModelManager modelManager] isModelDownloaded:sqRemoteModel];
    
    if (!isSq) {
        [self transLateModeDonwload:@"sq"];
    }
    if (!isEnglish) {
        [self transLateModeDonwload:@"en"];
    }
    if (!isChinese) {
        [self transLateModeDonwload:@"zh"];
    }
}

#pragma mark - TransLate

/// 下载语言模型
- (void)transLateModeDonwload:(NSString *)languageCode {
    MLKModelDownloadConditions *conditions =
        [[MLKModelDownloadConditions alloc] initWithAllowsCellularAccess:NO
                                             allowsBackgroundDownloading:YES];
    MLKTranslateRemoteModel *model =
        [MLKTranslateRemoteModel translateRemoteModelWithLanguage:languageCode];
    
    NSProgress *progress = [[MLKModelManager modelManager] downloadModel:model conditions:conditions];
    NSLog(@"[TSP]离线包开始下载 %@",progress.fileCompletedCount);
}

- (void)transLateWith:(NSString *)sourceString completeBlcok:(nonnull void (^)(BOOL, NSString * _Nonnull))completeBlcok{
    TSPLanguageModel * sourceModel = self.textSourceLanguage;
    TSPLanguageModel * targetModel = self.textTargetLanguage;
    if (self.isOcr) {
        sourceModel = self.ocrSourceLanguage;
        targetModel = self.ocrTargetLanguage;
    }
    if ([targetModel.code isEqualToString:@"auto"]) {
        targetModel.code = @"en";
    }
    /// auto 需要先识别 再翻译
    if ([sourceModel.language isEqualToString:@"Auto"]) {
        __weak typeof(self) weakSelf = self;
        MLKLanguageIdentification *languageId = [MLKLanguageIdentification languageIdentification];
        [languageId identifyPossibleLanguagesForText:sourceString completion:^(NSArray<MLKIdentifiedLanguage *> * _Nullable identifiedLanguages, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (identifiedLanguages && identifiedLanguages.count > 0) {
                MLKIdentifiedLanguage * shibie = identifiedLanguages[0];
                sourceModel.code = shibie.languageTag;
            }else {
                sourceModel.code = @"en";
            }
            [strongSelf transLateSourceModel:sourceModel targetModel:targetModel sourceString:sourceString completeBlcok:completeBlcok];
        }];
    }else {
        [self transLateSourceModel:sourceModel targetModel:targetModel sourceString:sourceString completeBlcok:completeBlcok];
    }
}

- (void)transLateSourceModel:(TSPLanguageModel *)sourceModel targetModel:(TSPLanguageModel *)targetModel sourceString:(NSString *)sourceString completeBlcok:(nonnull void (^)(BOOL, NSString * _Nonnull))completeBlcok {
    self.completeBlcok = completeBlcok;
    MLKTranslatorOptions *options = [[MLKTranslatorOptions alloc] initWithSourceLanguage:sourceModel.code targetLanguage:targetModel.code];
    MLKTranslator *transLator = [MLKTranslator translatorWithOptions:options];
    
    ///判断语言包是否已下载
    MLKTranslateRemoteModel * sourceRemoteModel = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:sourceModel.code];
    MLKTranslateRemoteModel * targetRemoteModel = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:targetModel.code];
    
    if ([sourceModel.code isEqualToString:targetModel.code]) {
        if (completeBlcok) {
            completeBlcok(YES,sourceString);
        }
        return;
    }
    
    BOOL isSourceModel = [[MLKModelManager modelManager] isModelDownloaded:sourceRemoteModel];
    BOOL isTargetModel = [[MLKModelManager modelManager] isModelDownloaded:targetRemoteModel];
    ///使用SDK离线翻译 如果都下载了
    if (isSourceModel && isTargetModel) {
        [transLator downloadModelIfNeededWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"[TSP] Failed to ensure model downloaded with error");
                completeBlcok(NO,@"");
            }else {
                [transLator translateText:sourceString completion:^(NSString * _Nullable result, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"[TSP] Translate with error");
                        if (completeBlcok) {
                            completeBlcok(NO,@"");
                        }
                    }else {
                        if (result) {
                            NSLog(@"[TSP] 翻译完成. %@",result);
                            if (completeBlcok) {
                                completeBlcok(YES,result);
                            }
                        }else {
                            NSLog(@"[TSP] Translate text is nil");
                            if (completeBlcok) {
                                completeBlcok(NO,@"");
                            }
                        }
                    }
                }];
            }
        }];
    }
    ///使用bi ying 网页翻译 & 并同时开启离线包下载
    else {
        if (!isSourceModel) {
            [self transLateModeDonwload:sourceModel.code];
        }
        if (!isTargetModel) {
            [self transLateModeDonwload:targetModel.code];
        }
        NSLog(@"[TSP] 翻译包没完全下载");
        NSString * sourceCode = sourceModel.code;
        NSString * targetCode = targetModel.code;
        if ([sourceModel.code isEqualToString:@"zh"]) {
            sourceCode = @"zh-Hans";
        }
        if ([targetModel.code isEqualToString:@"zh"]) {
            targetCode = @"zh-Hans";
        }
        NSLog(@"[TSP] 开始网页翻译.");
        NSString * biyingUrl = [NSString stringWithFormat:@"https://www.bing.com/translator/?ref=TThis&text=%@&from=%@&to=%@",sourceString,sourceCode,targetCode];
        NSString *encodedUrlStr = [biyingUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:encodedUrlStr];
        if (url) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

- (void)exchangeLanguage:(BOOL)isOcr {
    TSPLanguageModel * tempModel = nil;
    if (isOcr) {
        tempModel = self.ocrSourceLanguage;
        self.ocrSourceLanguage = self.ocrTargetLanguage;
        self.ocrTargetLanguage = tempModel;
    }else {
        tempModel = self.textSourceLanguage;
        self.textSourceLanguage = self.textTargetLanguage;
        self.textTargetLanguage = tempModel;
    }
}

///OCR 识别并翻译
- (void)ocrTransLateWith:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation completeBlcok:(void (^)(BOOL, NSString * _Nonnull))completeBlcok {
    
    MLKCommonTextRecognizerOptions *options = [[MLKTextRecognizerOptions alloc] init];
    if ([self.ocrSourceLanguage.code isEqualToString:@"zh"]) {
        options = [[MLKChineseTextRecognizerOptions alloc] init];
    }else if ([self.ocrSourceLanguage.code isEqualToString:@"ja"]) {
        options = [[MLKJapaneseTextRecognizerOptions alloc] init];
    }else if ([self.ocrSourceLanguage.code isEqualToString:@"ko"]) {
        options = [[MLKKoreanTextRecognizerOptions alloc] init];
    }
    MLKTextRecognizer * textRecognizer = [MLKTextRecognizer textRecognizerWithOptions:options];
    
    MLKVisionImage * visionImage = [[MLKVisionImage alloc] initWithImage:sourceImage];
    visionImage.orientation = orientation;
    
    ///从图片中提取文字
    __weak typeof(self) weakSelf = self;
    [textRecognizer processImage:visionImage completion:^(MLKText * _Nullable text, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"[TSP] 图片识别错误");
        }else {
            NSLog(@"[TSP] 图片识别出的文本 ======== %@",text.text);
            [strongSelf transLateWith:text.text completeBlcok:^(BOOL isSucces, NSString * _Nonnull result) {
                if (completeBlcok) {
                    completeBlcok(isSucces,result);
                }
            }];
        }
    }];
}

#pragma mark - Language

- (void)loadAllLanguages {
    ///首字母排序
    NSArray * originalArray = [MLKTranslateAllLanguages() allObjects];
    NSMutableArray * tempArrays = @[].mutableCopy;
    TSPLanguageModel * englishModel = [[TSPLanguageModel alloc] init];
    englishModel.code = @"en";
    englishModel.language = @"English";
    for (NSString * code in originalArray) {
        NSLog(@"code ==================== %@",code);
        NSString * languageName = [[NSLocale currentLocale] localizedStringForLanguageCode:code];
        NSLog(@"language =================== %@",languageName);
        TSPLanguageModel * model = [[TSPLanguageModel alloc] init];
        model.code = code;
        model.language = [languageName capitalizedString];
        [tempArrays addObject:model];
    }
    [self.allLanguageArrays addObjectsFromArray:[self ascendingOrderWithEnglishFirstChar:tempArrays]];
    TSPLanguageModel * autoModel = [[TSPLanguageModel alloc] init];
    autoModel.code = @"auto";
    autoModel.language = @"Auto";
    [self.allLanguageArrays insertObject:autoModel atIndex:0];
    
    /// 如果有缓存 读取缓存
    self.textSourceLanguage = [self.languageModelDicts objectForKey:textSourceKey]?[self.languageModelDicts objectForKey:textSourceKey]:autoModel.mutableCopy;
    self.textTargetLanguage = [self.languageModelDicts objectForKey:textTargetKey]?[self.languageModelDicts objectForKey:textTargetKey]:englishModel.mutableCopy;
    self.ocrSourceLanguage = [self.languageModelDicts objectForKey:ocrSourceKey]?[self.languageModelDicts objectForKey:ocrSourceKey]:autoModel.mutableCopy;
    self.ocrTargetLanguage = [self.languageModelDicts objectForKey:ocrTargetKey]?[self.languageModelDicts objectForKey:ocrTargetKey]:englishModel.mutableCopy;
    
    if (self.languageModelDicts.allKeys <= 0) {
        [self.languageModelDicts setObject:self.textSourceLanguage forKey:textSourceKey];
        [self.languageModelDicts setObject:self.textTargetLanguage forKey:textTargetKey];
        [self.languageModelDicts setObject:self.ocrSourceLanguage forKey:ocrSourceKey];
        [self.languageModelDicts setObject:self.ocrTargetLanguage forKey:ocrTargetKey];
        [self updateSandbox];
    }
}

- (NSMutableArray *)ascendingOrderWithEnglishFirstChar:(NSArray *)sortArray{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    //sz : 首字母
    for (char sz = 'a'; sz <= 'z'; ++sz) {
        for (int i = 0; i < [sortArray count]; ++i) {
            TSPLanguageModel * autoModel  = sortArray[i];
            // dKey : 单个的key
            NSString *dKey = autoModel.language.lowercaseString;
            // dszm : 单个首字母
            NSString *dSzm = [dKey substringToIndex:1];
           // NSLog(@"单个Key：%@ \n key的首字母:%@",dKey,dSzm);
            if ([[NSString stringWithFormat:@"%c",sz] isEqualToString:dSzm]) {
                [resultArray addObject:autoModel];
            }
        }
    }
    
    return resultArray;
}

- (BOOL)checkCurrentSelected:(TSPLanguageModel *)model {
    return [[self getCurrentModel].language isEqualToString:model.language];
}

- (void)updateLanguageModel:(TSPLanguageModel *)model {
    if (self.isOcr) {
        if (self.isSource) {
            self.ocrSourceLanguage = model;
            [self.languageModelDicts setObject:model forKey:ocrSourceKey];
        }else {
            self.ocrTargetLanguage = model;
            [self.languageModelDicts setObject:model forKey:ocrTargetKey];
        }
    }else {
        if (self.isSource) {
            self.textSourceLanguage = model;
            [self.languageModelDicts setObject:model forKey:textSourceKey];
        }else {
            self.textTargetLanguage = model;
            [self.languageModelDicts setObject:model forKey:textTargetKey];
        }
    }
    [self updateSandbox];
}

- (void)updateSandbox {
    [NSKeyedArchiver archiveRootObject:self.languageModelDicts toFile:self.sandboxFilePath];
}

- (TSPLanguageModel *)getCurrentModel {
    TSPLanguageModel * currentModel = nil;
    if (self.isOcr) {
        if (self.isSource) {
            currentModel = self.ocrSourceLanguage;
        }else {
            currentModel = self.ocrTargetLanguage;
        }
    }else {
        if (self.isSource) {
            currentModel = self.textSourceLanguage;
        }else {
            currentModel = self.textTargetLanguage;
        }
    }
    return currentModel;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"[TSP] web开始加载");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"[TSP] web加载失败");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"[TSP] web加载完成");
      NSString *js = @"document.getElementById('tta_output_ta').value";
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
              NSLog(@"[TSP] result: %@\n error: %@", result, error);
              if (error) {
                  NSLog(@"[TSP] 注入js失败, %@", error.localizedDescription);
                  return;
              }
              
              if ([result isKindOfClass:[NSString class]] && ![result isEqualToString:@""]) {
                  NSLog(@"[TSP] 注入js成功获取%@", result);
                  if (![result isEqualToString:@" ..."]) {
                      if (self.completeBlcok) {
                          self.completeBlcok(YES, result);
                      }
                  } else {
                      if (self.completeBlcok) {
                          self.completeBlcok(NO, @"");
                      }
                  }
              }
          }];
      });
}

#pragma mark - Getter

- (NSMutableArray<TSPLanguageModel *> *)allLanguageArrays {
    if (!_allLanguageArrays) {
        _allLanguageArrays = [[NSMutableArray alloc] init];
    }
    return _allLanguageArrays;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (NSMutableDictionary *)languageModelDicts {
    if (!_languageModelDicts) {
        _languageModelDicts = [[NSMutableDictionary alloc] init];
    }
    return _languageModelDicts;
}

@end
