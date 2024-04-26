//
//  TSPVpnServerListViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnServerListViewController.h"
#import "TSPVpnServerListTableViewCell.h"

@interface TSPVpnServerListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * contentViw;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation TSPVpnServerListViewController

- (NSString *)navTitle {
    return @"Change Servers";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSource addObjectsFromArray:[TSPAppManager instance].vpnModelList.mutableCopy];
    [self.view addSubview:self.contentViw];
    [self.contentViw addSubview:self.tableView];
    
    [self.contentViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(16));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentViw);
    }];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

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
    TSPVpnServerListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[TSPVpnServerListTableViewCell identifier] forIndexPath:indexPath];
    [cell loadServerModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPVpnModel * vpnModel = self.dataSource[indexPath.row];
    /// 如果服务器与当前连接选择相同 就不管
    if ([TSPVpnHelper shareInstance].vpnState == TSPVpnHelperStateConnected) {
        if ([vpnModel.titleName isEqualToString:[TSPAppManager instance].currentVpnModel.titleName]) {
            return;
        }
    }
    [TSPAppManager instance].currentVpnModel = vpnModel;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReconnectionVpnNoti object:nil];
}

#pragma mark - Getter

- (UIView *)contentViw {
    if (!_contentViw) {
        _contentViw = [[UIView alloc] init];
        _contentViw.backgroundColor = [UIColor blackColor];
    }
    return _contentViw;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[TSPVpnServerListTableViewCell class] forCellReuseIdentifier:[TSPVpnServerListTableViewCell identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
