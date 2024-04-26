//
//  TSPLanguageModel.h
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSPLanguageModel : NSObject <NSCopying, NSMutableCopying, NSCoding>

@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * code;

@end

NS_ASSUME_NONNULL_END
