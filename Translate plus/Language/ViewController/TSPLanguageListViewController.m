//
//  TSPLanguageListViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/22.
//

#import "TSPLanguageListViewController.h"
#import "TSPLanguageListTableViewCell.h"
#import "TSPLanguageModel.h"

@interface TSPLanguageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation TSPLanguageListViewController

- (void)dealloc {
    
}

- (NSString *)navTitle {
    return @"Language";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initializeAppearance];
}

- (void)initDataSource {
    [self.dataSource addObjectsFromArray:[TSPTranslateManager instance].allLanguageArrays];
}

- (void)initializeAppearance {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(TSPAdapterHeight(-16));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource * delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TSPAdapterHeight(72);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPLanguageListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[TSPLanguageListTableViewCell identifier] forIndexPath:indexPath];
    [cell loadLanguageModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSPLanguageModel * model = self.dataSource[indexPath.row];
    [[TSPTranslateManager instance] updateLanguageModel:model];
    [tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateLanguage" object:nil];
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TSPLanguageListTableViewCell class] forCellReuseIdentifier:[TSPLanguageListTableViewCell identifier]];
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
