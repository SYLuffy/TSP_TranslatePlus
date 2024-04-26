//
//  TSPStripEventView.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSPStripType) {
    TSPStripTypeVpn,
    TSPStripTypeSetting,
};

@interface TSPStripEventView : UIView

- (instancetype)initWithStripType:(TSPStripType)stripType;

@end

NS_ASSUME_NONNULL_END
