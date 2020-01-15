//
//  THCamerController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/28.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "THCamerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static const NSString *THCmaerAdjustExposureContext;

@interface THCamerController()

@property(nonatomic,strong) dispatch_queue_t videoQueue;
@property(nonatomic,strong) AVCaptureSession *capatureSession;
@property(nonatomic,strong) AVCaptureDeviceInput *activeVideoInput;

@property(nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property(nonatomic,strong) AVCaptureMovieFileOutput *movieOutput;
@property(nonatomic,strong) NSURL *outputURL;

@end

@implementation THCamerController

/***
 MARK: 没必须要了; 如果想要详细的写一个相机或者对这些类有一个详细的了解 可以照书上的来, 但是太慢了
    目的是 熟悉AVFoundation的j框架结构, 然后去熟练使用GPUimage, 以后需要用到再详细的学习;
 */


//
- (BOOL)setupSession:(NSError *__autoreleasing  _Nullable *)error {
    self.capatureSession = [[AVCaptureSession alloc]init];
    self.capatureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //Set up default camer video
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //支持自动对焦
    if ([videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([videoDevice lockForConfiguration:&error]) {
            videoDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [videoDevice unlockForConfiguration];
        }else{
            NSLog(@"此设备不支持自动对焦  %@",error);
        }
    }
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    if (videoInput) {
        if ([self.capatureSession canAddInput:videoInput]) {
            [self.capatureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    }else{
        return  NO;
    }
    
    //Setup default microphone
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    if (audioInput) {
        if ([self.capatureSession canAddInput:audioInput]) {
            [self.capatureSession addInput:audioInput];
        }
    }else{
        return  NO;
    }
    
    //Setup the still image output
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    self.imageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    if ([self.capatureSession canAddOutput:self.imageOutput]) {
        [self.capatureSession addOutput:self.imageOutput];
    }
    
    //Setup movie file output
    self.movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    if ([self.capatureSession canAddOutput:self.movieOutput]) {
        [self.capatureSession addOutput:self.movieOutput];
    }
    
    self.videoQueue = dispatch_queue_create("com.taparmonic.VideoQueue", NULL);
    return YES;
}

//MARK: 启动和停止捕捉会话
- (void)startSession {
    if (![self.capatureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.capatureSession startRunning];
        });
    }
}

- (void)stopSession {
    if ([self.capatureSession isRunning]) {
        [self.capatureSession stopRunning];
    }
}

//MARK: 摄像头相关方法
- (AVCaptureDevice *)camerWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified] devices];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

//当前使用的摄像头
- (AVCaptureDevice *)activeCamer{
    return self.activeVideoInput.device;
}

//未使用的摄像头
- (AVCaptureDevice *)inactiveCamers {
    AVCaptureDevice *device = nil;
    if (self.camerCount > 1) {
        if ([self activeCamer].position == AVCaptureDevicePositionBack) {
            device = [self camerWithPosition:AVCaptureDevicePositionFront];
        }else{
            device = [self camerWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}



- (BOOL)canSwitchCamers {
    return self.camerCount > 1;
}

- (NSUInteger)camerCount {
    return [[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified] devices].count;
}

- (BOOL)switchCamers {
    if (![self canSwitchCamers]) {
        return NO;
    }
    NSError *error;
    AVCaptureDevice *device = [self inactiveCamers];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (videoInput) {
        //如果想给一个正在运行的会话做些改变
        //或者比预设情况,更加精细的水平调整会话参数
        [self.capatureSession beginConfiguration];
        [self.capatureSession removeInput:self.activeVideoInput];
        if ([self.capatureSession canAddInput:videoInput]) {
            [self.capatureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }else{
            [self.capatureSession addInput:self.activeVideoInput];
        }
        //改变之后的设置 提交以生效
        [self.capatureSession commitConfiguration];
    }else{
        [self.delegate deviceConfigurationFailedWithError:error];
        return NO;
    }
    return YES;
    
}


//MARK: 调整焦距和曝光

//是否支持对焦
- (BOOL)camerSupportsTapToFocus {
    return [[self activeCamer] isFocusPointOfInterestSupported];
}

//点击的对焦的点, 已经从屏幕坐标转换为捕捉设备坐标
- (void)focusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamer];
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        }else{
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

//是否支持曝光
- (BOOL)camerSupportsTapToExpose {
    return [[self activeCamer] isExposurePointOfInterestSupported];
}

- (void)exposeAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self activeCamer];
    
    AVCaptureExposureMode exposeMode = AVCaptureExposureModeContinuousAutoExposure;
    if (device.isExposurePointOfInterestSupported && [device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.exposurePointOfInterest = point;
            device.exposureMode = exposeMode;
            
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:&THCmaerAdjustExposureContext];
            }
            [device unlockForConfiguration];
        }else{
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == &THCmaerAdjustExposureContext) {
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        if (!device.isAdjustingExposure &&[device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            [object removeObserver:self forKeyPath:@"adjustingExposure" context:&THCmaerAdjustExposureContext];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                }else{
                    [self.delegate deviceConfigurationFailedWithError:error];
                }
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//MARK: 重新设置对焦和曝光

- (void)resetFocusAndExposureModes {
    AVCaptureDevice *device = [self activeCamer];
    
    AVCaptureFocusMode focusModel = AVCaptureFocusModeAutoFocus;
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusModel];
    
    AVCaptureExposureMode exposeModel = AVCaptureExposureModeContinuousAutoExposure;
    BOOL canResetExpose = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposeModel];
    
    CGPoint point = {0.5f,0.5f};
    
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {
            device.focusMode = focusModel;
            device.focusPointOfInterest = point;
        }
        if (canResetExpose) {
            device.exposureMode = exposeModel;
            device.exposurePointOfInterest = point;
        }
        [device unlockForConfiguration];
    }
}

//MARK: 闪光灯和手电筒模式 这一模式省略

- (BOOL)camerHasFlash {
    return [[self activeCamer] hasFlash];
}

- (AVCaptureFlashMode)flashMode {
    return [[self activeCamer] flashMode];
}


//MARK: 静态图片输出
- (void)capatureStillImage {
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientraction];
    }
    id handle = ^(CMSampleBufferRef sampleBuffer,NSError *error) {
        if (sampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
        }else{
            NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    };
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:handle];
}

//
- (AVCaptureVideoOrientation)currentVideoOrientraction {
    AVCaptureVideoOrientation orientation;
    switch ([UIDevice currentDevice].orientation) {
            
            case UIDeviceOrientationPortrait:
            
            orientation = AVCaptureVideoOrientationPortrait;
            break;
            
            case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
            case UIDeviceOrientationPortraitUpsideDown:
                      
                orientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            
    }
    return orientation;
}

- (void)writeImageToAssetsLibray:(UIImage *)image {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(NSInteger)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [self postThumbnailnotification:image];
        }
    }];
}

- (void)postThumbnailnotification:(UIImage *)image{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:THTHumbnailCreateNoticfication object:image];
}




//MARK: 视频捕捉
- (BOOL)isRecording {
    return self.movieOutput.isRecording;
}

- (void)startRecrding {
    if (![self isRecording]) {
        AVCaptureConnection *videoConnectio = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([videoConnectio isVideoOrientationSupported]) {
            videoConnectio.videoOrientation = self.currentVideoOrientraction;
        }
        if ([videoConnectio isVideoStabilizationSupported]) {
            //视频稳定性
            videoConnectio.enablesVideoStabilizationWhenAvailable = YES;
        }
        AVCaptureDevice *device = [self activeCamer];
        if (device.isSmoothAutoFocusSupported) {
            NSError *error;
            
            if ([device lockForConfiguration:&error]) {
                device.smoothAutoFocusEnabled = YES;
                [device unlockForConfiguration];
            }else{
                [self.delegate deviceConfigurationFailedWithError:error];
            }
        }
        self.outputURL = [self uniqueURL];
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL recordingDelegate:self];
    }
}

- (NSURL *)uniqueURL {
//    NSFileManager *managerr = [NSFileManager defaultManager];
//    NSString *direPath = [managerr temporaryDirectory];
    NSURL *url;
    return url;
}



















































@end
