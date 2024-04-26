//
//  TSPSettingViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "TSPSettingViewController.h"
#import "TSPSettingModel.h"
#import "TSPSettingTableViewCell.h"
#import "TSPPrivacyViewController.h"
#import "TSPTermsServiceViewController.h"

@interface TSPSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView * listView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) BOOL isShareing;

@end

@implementation TSPSettingViewController

- (NSString *)navTitle {
    return @"Setting";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initializeAppearance];
}

- (void)initDataSource {
    NSArray * iconArrays = @[@"home_setting_share",@"home_setting_terms",@"home_setting_policy",@"home_setting_rateus"];
    NSArray * titleArrays = @[@"Share",@"Terms of Service",@"Privacy Policy",@"Rate Us"];
    for (int i = 0; i < iconArrays.count; i ++) {
        TSPSettingModel * model = [TSPSettingModel new];
        model.iconName = iconArrays[i];
        model.titleName = titleArrays[i];
        model.settingType = i;
        [self.dataSource addObject:model];
    }
}

- (void)initializeAppearance {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.listView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(16));
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.listView reloadData];
}

#pragma mark - UITableViewDataSource & delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TSPAdapterHeight(68);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[TSPSettingTableViewCell identifier] forIndexPath:indexPath];
    [cell loadSettingModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPSettingModel * model = self.dataSource[indexPath.row];
    switch (model.settingType) {
        case TSPSettingTypeShare:
            [self shareContent];
            break;
        case TSPSettingTypeTerms: {
            TSPTermsServiceViewController * termsVc = [[TSPTermsServiceViewController alloc] init];
            termsVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:termsVc animated:YES completion:nil];
        }
            break;
        case TSPSettingTypePrivacy: {
            TSPPrivacyViewController * priVc = [[TSPPrivacyViewController alloc] init];
            priVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:priVc animated:YES completion:nil];
        }
            break;
        case TSPSettingTypeRateUs: {
            [TSPToast showMessage:@"This feature is currently under development, please stay tuned ~~" duration:1.5 finishHandler:nil];
            break;
        }
        default:
            break;
    }
}

- (void)shareContent {
    /// 未上线 暂时没有商店地址
    [TSPToast showMessage:@"This feature is currently under development, please stay tuned ~~" duration:1.5 finishHandler:nil];
//    if (self.isShareing) {
//        return;
//    }
//    self.isShareing = YES;
//    
//        NSString *textToShare = @"share url";
//       
//        NSArray *activityItems = @[textToShare, urlToShare];
//        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//
//        
//        // 在 iPad 上，需要设置 popoverPresentationController 来指定分享界面的弹出位置
//        activityViewController.popoverPresentationController.sourceView = self.view;
//        activityViewController.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.frame), 0, 0);
//        __weak typeof(self) weakSelf = self;
//        [self presentViewController:activityViewController animated:YES completion:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            strongSelf.isShareing = NO;
//        }];
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor = [UIColor blackColor];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_listView registerClass:[TSPSettingTableViewCell class] forCellReuseIdentifier:[TSPSettingTableViewCell identifier]];
    }
    return _listView;
}

@end
