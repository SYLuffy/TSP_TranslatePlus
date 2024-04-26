//
//  TSPPrivacyViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/21.
//

#import "TSPPrivacyViewController.h"

@interface TSPPrivacyViewController ()

@property (nonatomic, strong)UITextView * contentView;

@end

@implementation TSPPrivacyViewController

- (NSString *)navTitle {
    return @"Privacy policy";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(TSPAdapterHeight(20));
        make.right.mas_equalTo(self.view.mas_right).offset(TSPAdapterHeight(-20));
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    [self loadingPrivacyInfo];
}

- (void)loadingPrivacyInfo {
    __block NSAttributedString *attributedString = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"privacy policy" ofType:@"rtf"];
        if (filePath) {
            NSData *rtfData = [NSData dataWithContentsOfFile:filePath];
            if (rtfData) {
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType};
                attributedString = [[NSAttributedString alloc] initWithData:rtfData options:options documentAttributes:nil error:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (attributedString) {
                self.contentView.attributedText = attributedString;
            }
        });
    });
}

#pragma mark - Getter

- (UITextView *)contentView {
    if (!_contentView) {
        _contentView = [[UITextView alloc] init];
        _contentView.editable = NO;
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.showsVerticalScrollIndicator = NO;
    }
    return _contentView;
}

@end
