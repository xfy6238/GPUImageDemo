//
//  VideoFilterController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/12.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "VideoFilterController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface VideoFilterController ()

@property (nonatomic,strong) GPUImageVideoCamera *videoCamer;
@property (nonatomic,strong) GPUImageOutput <GPUImageInput> *filter;
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic,strong) GPUImageView *filterView;

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) long labelTime;
@property (nonatomic,strong) NSTimer *mTimer;

@property (nonatomic,strong) CADisplayLink *mDisplayLink;

@end

@implementation VideoFilterController

- (void)viewDidLoad {
    [super viewDidLoad];


    //初始化
    _videoCamer = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamer.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //因为要设置audioEncodingTarget, 所以提前把音频的输入和输出加入,不然第一帧会黑屏
    [_videoCamer addAudioInputsAndOutputs];
    
    //滤镜
    _filter = [[GPUImageSepiaFilter alloc]init];
    //显示图
    _filterView = [[GPUImageView alloc]initWithFrame:self.view.frame];
    self.view = _filterView;
    
    //形成滤镜链
    // 渲染后的视频
    //1. 用来在屏幕上显示图像
    //2. 通过GPUimageMovieWriter
    [_videoCamer addTarget:_filter];
    [_filter addTarget:_filterView];
    //启动开始捕捉画面
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoCamer startCameraCapture];
    });

    [self configureUI];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.videoCamer.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }];
    
    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [_mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

//MARK: 私有方法
- (void)displaylink:(id)sender {
    NSLog(@"test");
}

- (void)onTimer:(id)sender {
    _label.text = [NSString stringWithFormat:@"录制时间%ld",_labelTime++];
    [_label sizeToFit];
}


- (void)onClick:(UIButton *)sender {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    NSURL *movieUrl = [NSURL fileURLWithPath:pathToMovie];
    if ([sender.currentTitle isEqualToString:@"录制"]) { //开始录制,将捕获的数据i
        [sender setTitle:@"结束" forState:UIControlStateNormal];
        //如果存在文件,AVAssetWrite会有异常,删除旧文件
        unlink([pathToMovie UTF8String]);
        
        //这个是用来录制视频(其实是将此时相机捕获的数据保存起来, 只是还没有写入到文件系统里)
        _movieWriter = [[GPUImageMovieWriter alloc]initWithMovieURL:movieUrl size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
        
        //滤镜之后
        [_filter addTarget:_movieWriter];
        //这里设置了audioEncodingTarget(音频编码目标) , 捕获的音频会给设定好的目标(_movieWriter),将音频数据保存 如果不提前添加音频的输入输出,会导致第一帧黑屏
        _videoCamer.audioEncodingTarget = _movieWriter;
        
        //开始录制  保存的时候 也是滤镜处理之后的图像  一个滤镜可以有多个出口
        [_movieWriter startRecording];
        
        _labelTime = 0;
        _label.hidden = NO;
        [self onTimer:nil];
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    } else {
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        _label.hidden = YES;
        if (_mTimer) {
            [_mTimer invalidate];
            _mTimer = nil;
        }
        
        [_filter removeTarget:_movieWriter];
        _videoCamer.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        
        ALAssetsLibrary *liabrary = [[ALAssetsLibrary alloc]init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie)) {
            [liabrary writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                    UIAlertController *con;
                    if (error) {
                        con = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"视频保存失败" preferredStyle:UIAlertControllerStyleAlert];
              
                    }else{
                        con = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"视频保存成功" preferredStyle:UIAlertControllerStyleAlert];
                    }
                    [con addAction:action];
                                  [self.navigationController presentViewController:con animated:YES completion:nil];
                });
                
            }];
        }
    }
}


- (void)updateSliderValue:(id)sender {
    [(GPUImageSepiaFilter *)_filter setIntensity:[(UISlider *)sender value]];
}


//MARK: UI
-(void)configureUI{
    CGFloat heigth = [UIScreen mainScreen].bounds.size.height;
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, heigth - 50 - 5, 50, 50)];
    [_btn setTitle:@"录制" forState:UIControlStateNormal];
    [_btn sizeToFit];
    [self.view addSubview:_btn];
    [_btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(80, heigth - 100 - 5, 50, 100)];
    _label.hidden = YES;
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(150,heigth - 40, 100, 40)];
    [slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

@end
