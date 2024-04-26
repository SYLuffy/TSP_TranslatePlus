//
//  TSPOcrTranslateButtonView.h
//  Translate plus
//
//  Created by shen on 2024/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPOcrTranslateButtonView : UIView

@property (nonatomic, copy)void(^tapClick)(void);

- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
