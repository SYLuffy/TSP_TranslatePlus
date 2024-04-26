//
//  TSPOcrTranslateViewController.m
//  Translate plus
//
//  Created by shen on 2024/4/21.
//

#import "TSPOcrTranslateViewController.h"
#import "TSPOcrTranslateButtonView.h"
#import "TSPOcrTranslateReverseView.h"
#import <AVFoundation/AVFoundation.h>
#import "TSPLanguageListViewController.h"
#import "TSPOcrResultView.h"

@interface TSPOcrTranslateViewController () <AVCapturePhotoCaptureDelegate, TSPTranslatingProtocol>

@property (nonatomic, strong) TSPOcrTranslateReverseView * reverseView;
@property (nonatomic, strong) TSPOcrTranslateButtonView * sourceButton;
@property (nonatomic, strong) TSPOcrTranslateButtonView * targetButton;
@property (nonatomic, strong) TSPOcrResultView * resultView;

@property (nonatomic, strong) UIButton * cameraOcrButton;
@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput * imageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, assign) BOOL isSuccessed;
@property (nonatomic, strong) NSString * transLateString;
@property (nonatomic, assign) BOOL isEnterBackground;

@end

@implementation TSPOcrTranslateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)navTitle {
    return @"OCR Translateion";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TSPTranslateManager instance] downloadDefaultLanguageModel];
    [TSPTranslateManager instance].isOcr = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLanguage) name:@"kUpdateLanguage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackGround:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForeGround:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    [self initializeAppearance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.captureSession isRunning]) {
        return;
    }
    [TSPAppManager isHasCameraAuthorityWithisShowAlert:^(BOOL isSuccess) {
        if (isSuccess) {
            [self cameraPremissione];
        }
    }];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.sourceButton];
    [self.view addSubview:self.reverseView];
    [self.view addSubview:self.targetButton];
    [self.view addSubview:self.cameraOcrButton];
    [self.view addSubview:self.resultView];
    
    [self.reverseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(52));
        make.height.mas_equalTo(TSPAdapterHeight(44));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.navView.mas_bottom).offset(TSPAdapterHeight(20));
    }];
    
    [self.sourceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(120));
        make.height.mas_equalTo(TSPAdapterHeight(44));
        make.centerY.mas_equalTo(self.reverseView.mas_centerY);
        make.right.mas_equalTo(self.reverseView.mas_left).offset(TSPAdapterHeight(-7));
    }];
    
    [self.targetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TSPAdapterHeight(120));
        make.height.mas_equalTo(TSPAdapterHeight(44));
        make.centerY.mas_equalTo(self.reverseView.mas_centerY);
        make.left.mas_equalTo(self.reverseView.mas_right).offset(TSPAdapterHeight(7));
    }];
    
    [self.cameraOcrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TSPAdapterHeight(72));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(TSPAdapterHeight(-36));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self updateLanguage];
}

- (void)handleBackClickEvent {
    if (self.isSuccessed && !self.resultView.hidden) {
        [self retryStartRunning];
    }else {
        if (self.isFormVpnResult) {
            [[UIApplication sharedApplication].windows.lastObject.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)retryStartRunning {
    self.isSuccessed = NO;
    self.transLateString = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
    self.resultView.hidden = YES;
}

#pragma mark - Action

- (void)updateLanguage {
    [self.sourceButton setTitle:[TSPTranslateManager instance].ocrSourceLanguage.language];
    [self.targetButton setTitle:[TSPTranslateManager instance].ocrTargetLanguage.language];
}

- (void)sourceAction {
    [TSPTranslateManager instance].isSource = YES;
    TSPLanguageListViewController * languageListVC = [[TSPLanguageListViewController alloc] init];
    languageListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:languageListVC animated:YES completion:nil];
}

- (void)tartgetAction {
    [TSPTranslateManager instance].isSource = NO;
    TSPLanguageListViewController * languageListVC = [[TSPLanguageListViewController alloc] init];
    languageListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:languageListVC animated:YES completion:nil];
}

- (void)exchangeAction {
    [[TSPTranslateManager instance] exchangeLanguage:YES];
    [self updateLanguage];
}

- (void)resultCopyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.transLateString];
    [TSPToast showMessage:@"Copied" duration:3 finishHandler:nil];
    [self retryStartRunning];
}

- (void)resultRetryAction {
    [self retryStartRunning];
}

- (void)enterForeGround:(NSNotification *)noti {
    self.isEnterBackground = NO;
}

- (void)enterBackGround:(NSNotification *)noti {
    self.isEnterBackground = YES;
    [TSPTranslatingView stopTranslating];
    [self resultRetryAction];
}

#pragma mark - camera

- (void)cameraPremissione {
    self.captureSession = [[AVCaptureSession alloc]init];
    
    [self.captureSession beginConfiguration];
    NSError * error = nil;
    ///设置输入设备（摄像头）
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    }
    
    ///设置输出
    self.imageOutput = [[AVCapturePhotoOutput alloc]init];
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    [self.captureSession commitConfiguration];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, TSPAdapterHeight(100), kTSPDeviceWidth, kTSPDeviceHeight - TSPAdapterHeight(100))];
        strongSelf.previewLayer.frame = aView.bounds; //预览层填充视图
        strongSelf.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [aView.layer addSublayer:self.previewLayer];
        [strongSelf.view insertSubview:aView atIndex:0];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
}

- (void)cameraOcrClick:(UIButton *)sender {
    if (![[TSPTranslateManager instance] checkShowNetworkNotReachableToast]) {
        __weak typeof(self) weakSelf = self;
        [TSPAppManager isHasCameraAuthorityWithisShowAlert:^(BOOL isSuccess) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (isSuccess && self.captureSession.isRunning) {
                [TSPTranslatingView showTranslatingWithSuperView:strongSelf.view delegate:strongSelf];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self.imageOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
                });
            }
        }];
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    UIImage *image = nil;
    UIImageOrientation orientation = UIImageOrientationUp;
    if (error != nil) {
        NSLog(@"[TSP] 拍照发生了错误");
        return;
    }
    if (![photo fileDataRepresentation]) {
        NSLog(@"[TSP] AVCapturePhoto发生了错误");
        return;
    }
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
            orientation = UIImageOrientationRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceDown:
            orientation = UIImageOrientationLeft;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = UIImageOrientationUp;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = UIImageOrientationDown;
            break;
        default:
            orientation = UIImageOrientationUp;
            break;
    }
    image = [[UIImage alloc] initWithData:[photo fileDataRepresentation]];
    NSLog(@"[TSP] 拍照成功");
    
    __weak typeof(self) weakSelf = self;
    [[TSPTranslateManager instance] ocrTransLateWith:image orientation:orientation completeBlcok:^(BOOL isSucces, NSString * _Nonnull result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isSucces) {
            strongSelf.isSuccessed = NO;
            [TSPToast showMessage:@"Failed to translate." duration:3 finishHandler:nil];
        }else if (!self.isEnterBackground){
            strongSelf.isSuccessed = YES;
            strongSelf.transLateString = result;
        }
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession stopRunning];
    });
}

#pragma mark - TSPTranslatingProtocol
- (void)loadingFinish {
    if (self.isEnterBackground) {
        self.isEnterBackground = NO;
        return;
    }
    if (self.isSuccessed) {
        self.resultView.hidden =NO;
        [self.resultView setTranslateText:self.transLateString];
    }else {
        NSLog(@"[TSP]  OCR Failed to translate.");
        [TSPToast showMessage:@"Failed to translate." duration:3 finishHandler:nil];
        [self retryStartRunning];
    }
}

#pragma mark - Getter

- (TSPOcrTranslateReverseView *)reverseView {
    if (!_reverseView) {
        _reverseView = [[TSPOcrTranslateReverseView alloc] init];
    }
    return _reverseView;
}

- (TSPOcrTranslateButtonView *)sourceButton {
    if (!_sourceButton) {
        _sourceButton = [[TSPOcrTranslateButtonView alloc] init];
        __weak typeof(self) weakSelf = self;
        _sourceButton.tapClick = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf sourceAction];
        };
    }
    return _sourceButton;
}

- (TSPOcrTranslateButtonView *)targetButton {
    if (!_targetButton) {
        _targetButton = [[TSPOcrTranslateButtonView alloc] init];
        __weak typeof(self) weakSelf = self;
        _targetButton.tapClick = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf tartgetAction];
        };
    }
    return _targetButton;
}

- (UIButton *)cameraOcrButton {
    if (!_cameraOcrButton) {
        _cameraOcrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraOcrButton addTarget:self action:@selector(cameraOcrClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraOcrButton setBackgroundImage:[UIImage imageNamed:@"home_ocrtranslate_camera"] forState:UIControlStateNormal];
    }
    return _cameraOcrButton;
}

- (TSPOcrResultView *)resultView {
    if (!_resultView) {
        _resultView = [[TSPOcrResultView alloc] init];
        _resultView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _resultView.resultCopyBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf resultCopyAction];
        };
        _resultView.resultRetryBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf resultRetryAction];
        };
    }
    return _resultView;
}

@end
