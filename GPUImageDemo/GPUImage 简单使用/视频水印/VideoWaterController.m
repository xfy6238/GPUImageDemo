//
//  VideoWaterController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/13.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "VideoWaterController.h"

#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface VideoWaterController ()

@property (nonatomic , strong) UILabel  *mLabel;

@property (nonatomic,strong) GPUImageMovie *movieFile;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic,strong) GPUImageVideoCamera *videoCamer;

@end

@implementation VideoWaterController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    GPUImageView *mView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.view = mView;
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 20, 100, 20)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
    
    //滤镜
    _filter = [[GPUImageDissolveBlendFilter alloc]init];
    [(GPUImageDissolveBlendFilter *)_filter setMix:0.5];
    
    //播放
    NSURL *sampleUrl = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    _movieFile = [[GPUImageMovie alloc]initWithURL:sampleUrl];
    //启用基准测试模式(在控制台上显示相关信息)
    _movieFile.runBenchmark = YES;
    //播放实际速度
    _movieFile.playAtActualSpeed = YES;


    //摄像头
    _videoCamer = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamer.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieUrl = [NSURL fileURLWithPath:pathToMovie];
    
    _movieWriter = [[GPUImageMovieWriter alloc]initWithMovieURL:movieUrl size:CGSizeMake(640, 480)];
    BOOL audioFromFile = YES;
    [_movieWriter setAudioProcessingCallback:^(SInt16 **samplesRef, CMItemCount numSamplesInBuffer) {
        
    }];
    
    //如果音频来源是文件
    if (audioFromFile) {
        //响应链
        [_movieFile addTarget:_filter];
        [_videoCamer addTarget:_filter];
        //是否通过音频
        _movieWriter.shouldPassthroughAudio = YES;
        _videoCamer.audioEncodingTarget = _movieWriter;
        [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    } else {//不使用音频文件, 使用麦克风采集音频
        //
        [_videoCamer addTarget:_filter];
        [_movieFile addTarget:_filter];
        //????
        _movieWriter.shouldPassthroughAudio = NO;
        _videoCamer.audioEncodingTarget = _movieWriter;
        _movieWriter.encodingLiveVideo = NO;
    }
    
    [_filter addTarget:mView];
    [_filter addTarget:_movieWriter];
    
    [_videoCamer startCameraCapture];
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    __weak typeof(self) weakSelf = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;

        //移除滤镜的输出目标
//        [strongSelf.filter removeTarget:strongSelf.movieWriter];
//        [strongSelf.movieWriter finishRecording];
        
        [strongSelf->_filter removeTarget:strongSelf->_movieWriter];
        [strongSelf->_movieWriter finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
           if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
           {
               [library writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *assetURL, NSError *error)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        }
                    });
                }];
           }
           else {
               NSLog(@"error mssg)");
           }
    }];
}

- (void)updateProgress {
    self.mLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(_movieFile.progress * 100)];
       [self.mLabel sizeToFit];
    
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
