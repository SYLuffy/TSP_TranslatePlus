//
//  TSPOcrResultView.h
//  Translate plus
//
//  Created by shen on 2024/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPOcrResultView : UIView

@property (nonatomic, copy)void(^resultCopyBlock)(void);
@property (nonatomic, copy)void(^resultRetryBlock)(void);

- (void)setTranslateText:(NSString *)translateText;

@end

NS_ASSUME_NONNULL_END
