//
//  TSPLanguageModel.m
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import "TSPLanguageModel.h"

@implementation TSPLanguageModel

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.language forKey:@"language"];
    [coder encodeObject:self.code forKey:@"code"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.language = [coder decodeObjectForKey:@"language"];
        self.code = [coder decodeObjectForKey:@"code"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TSPLanguageModel *copy = [[[self class] allocWithZone:zone] init];
    copy.language = self.language;
    copy.code = self.code;
    return copy;
}
 
- (id)mutableCopyWithZone:(NSZone *)zone {
    TSPLanguageModel *mutableCopy = [[[self class] allocWithZone:zone] init];
    mutableCopy.language = [self.language copy];
    mutableCopy.code = [self.code copy];
    return mutableCopy;
}

@end
