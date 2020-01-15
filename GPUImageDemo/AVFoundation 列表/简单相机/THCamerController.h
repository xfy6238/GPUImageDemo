//
//  THCamerController.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/28.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const THTHumbnailCreateNoticfication;

@protocol SimpleControllerDelegate <NSObject>

- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
- (void)assestLiabraryWriteFailedWithError:(NSError *)error;

@end
@interface THCamerController : NSObject

@property (nonatomic,weak) id<SimpleControllerDelegate>delegate;
@property (nonatomic,strong,readonly) AVCaptureSession *capatureSession;

//session Configuration
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

//Camer Devuce Support
- (BOOL)switchCamers;
- (BOOL)canSwitchCamers;

@property (nonatomic,readonly) NSUInteger camerCount;
@property (nonatomic,readonly) BOOL camerHasTouch;
@property (nonatomic,readonly) BOOL camerHasFlash;
@property (nonatomic,readonly) BOOL camerSupportsTapToFocus;
@property (nonatomic,readonly) BOOL camerSupportsTapToExpose;
@property (nonatomic) AVCaptureTorchMode torchMode;
@property (nonatomic) AVCaptureFlashMode flashMode;

//Tap to * Methods
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

//Media Capature Methods
//still Image Capature
- (void)capatureStillImage;

//Video Recording
- (void)startRecrding;
- (void)stopRecording;
- (BOOL)isRecording;

@end

NS_ASSUME_NONNULL_END
