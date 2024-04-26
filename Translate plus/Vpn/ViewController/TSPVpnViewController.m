//
//  TSPVpnViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/24.
//

#import "TSPVpnViewController.h"
#import "TSPVpnCardView.h"

@interface TSPVpnViewController ()

@property (nonatomic, strong) TSPVpnCardView * vpnCardView;
@property (nonatomic, assign)BOOL isStartConnect;

@end

@implementation TSPVpnViewController

- (instancetype)initWithNeedStartConnect:(BOOL)isStartConnect {
    self = [super init];
    if (self) {
        self.isStartConnect = isStartConnect;
    }
    return self;
}

- (NSString *)navTitle {
    return @"VPN";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.vpnCardView updateStatus];
    if (self.isStartConnect) {
        self.isStartConnect = NO;
        [self.vpnCardView clickEvent];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeAppearance];
}

- (void)initializeAppearance {
    [self.view addSubview:self.vpnCardView];
    [self.vpnCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}

- (void)vpnDisconnected {
    [self.vpnCardView updateUI:TSPVpnStatusNormal];
}

#pragma mark - Getter
- (TSPVpnCardView *)vpnCardView {
    if (!_vpnCardView) {
        _vpnCardView = [[TSPVpnCardView alloc] initWithVpnStatus:[TSPVpnHelper shareInstance].vpnState == TSPVpnHelperStateConnected?TSPVpnStatusConnected:TSPVpnStatusNormal];
    }
    return _vpnCardView;
}

@end
