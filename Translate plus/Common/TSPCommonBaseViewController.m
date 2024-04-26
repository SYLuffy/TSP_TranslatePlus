//
//  TSPCommonBaseViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPCommonBaseViewController.h"
#import "TSPCommonNavView.h"

@interface TSPCommonBaseViewController ()<TSPCommonProtocol>

@end

@implementation TSPCommonBaseViewController

- (NSString *)navTitle {
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(TSPAdapterHeight(100));
    }];
}

#pragma mark - TSPCommonProtocol
- (void)navBackClick {
    [self handleBackClickEvent];
}

- (void)handleBackClickEvent {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (TSPCommonNavView *)navView {
    if (!_navView) {
        _navView = [[TSPCommonNavView alloc] initWithNavTitle:[self navTitle]];
        _navView.delegate = self;
    }
    return _navView;
}

@end
