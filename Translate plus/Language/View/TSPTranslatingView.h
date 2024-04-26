//
//  TSPTranslatingView.h
//  Translate plus
//
//  Created by shen on 2024/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TSPTranslatingProtocol <NSObject>

- (void)loadingFinish;

@end

@interface TSPTranslatingView : UIView

@property (nonatomic, weak)id <TSPTranslatingProtocol> delegate;

+ (void)showTranslatingWithSuperView:(UIView *)superView delegate:(id <TSPTranslatingProtocol>)delegate;

+ (void)stopTranslating;

- (void)stopTranslating;

@end

NS_ASSUME_NONNULL_END
