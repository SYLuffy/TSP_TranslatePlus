//
//  TSPTextView.h
//  Translate plus
//
//  Created by shen on 2024/4/19.
//

#import <UIKit/UIKit.h>
@class TSPTextView;
NS_ASSUME_NONNULL_BEGIN

typedef void(^TSPTextViewwHandler)(TSPTextView *textView);

@interface TSPTextView : UITextView

+ (instancetype)textView;

- (void)addTextDidChangeHandler:(TSPTextViewwHandler)eventHandler;

- (void)addTextLengthDidMaxHandler:(TSPTextViewwHandler)maxHandler;

/**
 最大限制文本长度, 默认为无穷大, 即不限制, 如果被设为 0 也同样表示不限制字符数.
 */
@property (nonatomic, assign) NSUInteger maxLength;

/**
 圆角半径.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 边框宽度.
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 边框颜色.
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 placeholder, 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 placeholder文本颜色, 默认为#C7C7CD.
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 placeholder文本字体, 默认为UITextView的默认字体.
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 是否允许长按弹出UIMenuController, 默认为YES.
 */
@property (nonatomic, assign, getter=isCanPerformAction) BOOL canPerformAction;

/**
 该属性返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
 */
@property (nonatomic, readonly) NSString *formatText;

@end

NS_ASSUME_NONNULL_END
