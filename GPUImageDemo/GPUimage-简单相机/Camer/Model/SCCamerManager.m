//
//  SCCamerManager.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCamerManager.h"
#import "SCFileHelper.h"

static CGFloat const kMaxVideoScale = 6.0f;
static CGFloat const kMinVdieoScale = 1.0f;

static SCCamerManager *_camerManager;

@interface SCCamerManager ()

@property (nonatomic, strong) GPUImageStillCamera *camera;

#pragma mark 为什么要用weak
@property (nonatomic, weak) GPUImageView *outputView;

@property (nonatomic, strong) SCFilterHandler *currentFilterHandle;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, copy) NSString *currentTmpVideoPath;

@property (nonatomic) CGSize videoSize;

@end

@implementation SCCamerManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _camerManager = [[SCCamerManager alloc]init];
    });
    return _camerManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

//MARK: Public
- (void)takePhotoWithCompletion:(TakePhotoResult)completion {
    GPUImageFilter *lastFilter = self.currentFilterHadle.lastFilter;
    [self.camera capturePhotoAsImageProcessedUpToFilter:lastFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error && completion) {
            completion(nil, error);
            return ;
        }
        if (completion) {
            completion(processedImage, nil);
        }
    }];
}

- (void)recordVideo {
    [self setupMovieWriter];
    [self.movieWriter startRecording];
}

- (void)stopRecordVideoWithCompletion:(RecordVdieoResult)completion {
    @weakify(self);
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        @strongify(self);
        [self.movieWriter finishRecordingWithCompletionHandler:^{
            [self removeMovieWriter];
            if (completion) {
                completion(self.currentTmpVideoPath);
            }
        }];
    }];
}

- (void)addOutputView:(GPUImageView *)outputView {
    self.outputView = outputView;
}

- (void)startCapaturing {
    if (!self.outputView) {
        NSAssert(NO, @"output 未被赋值");
        return;
    }
    [self setupCamera];
    
    [self.camera addTarget:self.currentFilterHadle.firstFilter];
    [self.currentFilterHadle.lastFilter addTarget:self.outputView];
    
    [self.camera startCameraCapture];
}

- (void)rotateCamera {
    [self.camera rotateCamera];
    //切换摄像头 同步闪光灯
    [self syncFlashState];
}

- (void)closeFlashIfNeed {
    AVCaptureDevice *device = self.camera.inputCamera;
    if ([device hasFlash] && device.torchMode == AVCaptureTorchModeOn) {
        [device lockForConfiguration:nil];
        device.torchMode = AVCaptureTorchModeOff;
        device.flashMode = AVCaptureFlashModeOff;
        [device unlockForConfiguration];
    }
}

- (void)updateFlashMode {
    [self syncFlashState];
}

- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale {
    AVCaptureDevice *device = self.camera.inputCamera;
    
    CGFloat maxScale = kMaxVideoScale;
    CGFloat minScale = kMinVdieoScale;
    if (@available(iOS 11.0, *)) {
        maxScale = device.maxAvailableVideoZoomFactor;
    }
    scale = MAX(scale, minScale);
    scale = MIN(scale, maxScale);
    
    return scale;
}

- (NSTimeInterval)currenDuration {
    NSTimeInterval time = CMTimeGetSeconds(self.movieWriter.duration);
    return time;
}

//MARK: Custom Accessor

- (void)commonInit {
    [self setupFilterHandle];
    self.videoScale = 1.0;
    self.flashMode = SCCamerFlashModeOff;
    self.ratio = SCCamerRatio16v9;
    self.videoSize = [self videoSizeWithRatio:self.ratio];
}

- (void)setFlashMode:(SCCamerFlashMode)flashMode {
    _flashMode = flashMode;
    [self syncFlashState];
}

- (void)setFocusPoint:(CGPoint)focusPoint {
    _focusPoint = focusPoint;
    
    AVCaptureDevice *device = self.camera.inputCamera;
    
    //MARK: 坐标转换
    CGPoint currentPoint = CGPointMake(focusPoint.y / self.outputView.bounds.size.height , 1- focusPoint.x / self.outputView.bounds.size.width);
    if (self.camera.cameraPosition == AVCaptureDevicePositionFront) {
        currentPoint = CGPointMake(currentPoint.x, 1 - currentPoint.y);
    }
    [device lockForConfiguration:nil];
    
    if ([device isFocusPointOfInterestSupported] &&
        [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [device setFocusPointOfInterest:currentPoint];
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([device isExposurePointOfInterestSupported] &&
        [device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [device setExposurePointOfInterest:currentPoint];
        [device setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    [device unlockForConfiguration];
}

- (void)setVideoScale:(CGFloat)videoScale {
    _videoScale = videoScale;
    videoScale = [self availableVideoScaleWithScale:videoScale];
    
    AVCaptureDevice *device = self.camera.inputCamera;
    [device lockForConfiguration:nil];
    device.videoZoomFactor = videoScale;
    [device unlockForConfiguration];
}

- (void)setRatio:(SCCamerRatio)ratio {
    _ratio = ratio;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    if (ratio == SCCamerRatio1v1) {
        self.camera.captureSessionPreset = AVCaptureSessionPreset640x480;
        CGFloat space = (4 - 3) / 4.0; //竖直方向应该裁剪掉的空间
        rect = CGRectMake(0, space / 2, 1, 1 - space);
    }else if (ratio == SCCamerRatio4v3) {
        self.camera.captureSessionPreset = AVCaptureSessionPreset640x480;
    }else if (ratio == SCCamerRatio16v9) {
        self.camera.captureSessionPreset = AVCaptureSessionPreset1280x720;
    }else if (ratio == SCCamerRatioFull) {
        self.camera.captureSessionPreset = AVCaptureSessionPreset1280x720;
        CGFloat currenRation = SCREEN_HEIGHT / SCREEN_WIDTH;
        if (currenRation > 16.0 / 9.0) { //在水平方向剪裁
            CGFloat resutlWidth = 16.0 / currenRation;
            CGFloat space = (9.0 - resutlWidth) / 9.0;
            rect = CGRectMake(space / 2, 0, 1 - space, 1);
        } else {
            CGFloat resultHeight = 9.0 * currenRation;
            CGFloat space = (16.0 - resultHeight) / 16.0;
            rect = CGRectMake(0, space / 2, 1, 1 - space);
        }
    }
    [self.currentFilterHadle setCropRect:rect];
    self.videoSize = [self videoSizeWithRatio:ratio];
}


//MARK: Private

- (void)setupCamera {

    self.camera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    [self.camera addAudioInputsAndOutputs];
    
    self.currentFilterHadle.source = self.camera;
}


//MARK: 初始化MovieWriter
- (void)setupMovieWriter {
    NSString *videoPath = [SCFileHelper randomFilePathInTmpWithSuffix:@".m4v"];
    NSURL *videoURL  = [NSURL fileURLWithPath:videoPath];
    CGSize size = self.videoSize;
    
    self.movieWriter = [[GPUImageMovieWriter alloc]initWithMovieURL:videoURL size:size];
    
    GPUImageFilter *lastFilter = self.currentFilterHadle.lastFilter;
    [lastFilter addTarget:self.movieWriter];
    self.camera.audioEncodingTarget = self.movieWriter;
    
    self.movieWriter.shouldPassthroughAudio = YES;
    self.currentTmpVideoPath = videoPath;
}

//MARK: 移除MovieWriter
- (void)removeMovieWriter{
    if (!self.movieWriter) {
        return;
    }
    //不在保存捕捉的画面
    [self.currentFilterHadle.lastFilter removeTarget:self.movieWriter];
    self.camera.audioEncodingTarget = nil;
    self.movieWriter = nil;
}

//MARK:初始化FilterHandle
- (void)setupFilterHandle {
    self.currentFilterHadle = [[SCFilterHandler alloc]init];
    
    //添加滤镜效果
    [self.currentFilterHadle setEffectFilter:nil];
}


//MARK:  同步FlashMode
- (void)syncFlashState {
    AVCaptureDevice *device = self.camera.inputCamera;
    if (![device hasFlash] || self.camera.cameraPosition == AVCaptureDevicePositionFront) {
        [self closeFlashIfNeed];
        return;
    }
    [device lockForConfiguration:nil];
    switch (self.flashMode) {
        case SCCamerFlashModeOff:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        case SCCamerFlashModeOn:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeOn;
            break;
        case SCCamerFlashModeAuto:
            device.torchMode = AVCaptureTorchModeOff;
            device.flashMode = AVCaptureFlashModeAuto;
            break;
        case SCCamerFlashModeTorch:
            device.torchMode = AVCaptureTorchModeOn;
            device.flashMode = AVCaptureFlashModeOff;
            break;
        default:
            break;
    }
    [device unlockForConfiguration];
}

- (CGSize)videoSizeWithRatio:(SCCamerRatio)ratio {
    CGFloat videoWdith = SCREEN_WIDTH * SCREEN_SCALE;
    CGFloat videoHeight = 0;
    switch (ratio) {
        case SCCamerRatio1v1:
            videoHeight = videoWdith;
            break;
        case SCCamerRatio4v3:
            videoHeight = videoWdith / 3.0 * 4.0;
            break;
        case SCCamerRatio16v9:
            videoHeight = videoWdith / 9.0 * 16.0;
            break;
        case SCCamerRatioFull:
            videoHeight = SCREEN_HEIGHT *SCREEN_SCALE;
            break;
        default:
            break;
    }
    return CGSizeMake(videoWdith, videoHeight);
}

@end
;
