//
//  SimpleCamerViewController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/28.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SimpleCamerViewController.h"
#import "THPreviewView.h"
#import "THCamerController.h"

@interface SimpleCamerViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIButton *flashLampButton;
@property (weak, nonatomic) IBOutlet UILabel *recodTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *switchCamerButton;

@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet UIButton *camerButton;
@property (weak, nonatomic) IBOutlet UIScrollView *buttonScrollView;

@property (strong,nonatomic) THPreviewView *preView;
@property (strong,nonatomic) THCamerController *camerCon;

@end

@implementation SimpleCamerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _topBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _camerCon = [[THCamerController alloc]init];
    NSError *error = nil;
    [_camerCon setupSession:&error];
    [_camerCon startSession];
    
//    _preView = [[THPreviewView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _preView = [[THPreviewView alloc]initWithFrame:self.view.bounds];

    _preView.backgroundColor = [UIColor redColor];
    AVCaptureVideoPreviewLayer *preLayer = (AVCaptureVideoPreviewLayer *) _preView.layer;
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preView.session = _camerCon.capatureSession;
    [self.view insertSubview:_preView atIndex:0];
    
}

//MARK: 按钮方法
//闪光灯
- (IBAction)flashCamerButtonAction:(UIButton *)sender {
    
}

//切换摄像头
- (IBAction)switchCamerButtonAction:(UIButton *)sender {
    
}

//a拍照或者录像
- (IBAction)takeCamerButtonAction:(UIButton *)sender {
    
}

- (IBAction)selectPhotoAction:(UIButton *)sender {
}

- (IBAction)selectVideoAction:(UIButton *)sender {
    
}


//MARK:UI设置
- (void)setupUI{
    self.topBackView.backgroundColor = self.bottomBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    
}





















@end
