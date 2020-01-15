//
//  SCCamerManager.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCFilterHandler.h"

typedef void (^TakePhotoResult)(UIImage *resultImage, NSError *error);
typedef void (^RecordVdieoResult)(NSString *videoPath);
/**
 -闪光灯模式
 -Torch 常亮
 */

typedef NS_ENUM(NSUInteger, SCCamerFlashMode) {
    SCCamerFlashModeOff,
    SCCamerFlashModeOn,
    SCCamerFlashModeAuto,
    SCCamerFlashModeTorch
};

/**
相机比例
 -full:全屏 (iPhone X才有)
 */
typedef NS_ENUM(NSUInteger,SCCamerRatio) {
    SCCamerRatio1v1,
    SCCamerRatio4v3,
    SCCamerRatio16v9,
    SCCamerRatioFull
};


NS_ASSUME_NONNULL_BEGIN

@interface SCCamerManager : NSObject

@property (strong, nonatomic, readonly) GPUImageStillCamera *camera;


/// 滤镜
@property (strong, nonatomic) SCFilterHandler *currentFilterHadle;


/// 相机比例 默认16v9
@property (nonatomic) SCCamerRatio ratio;

/// 闪光灯模式
@property (nonatomic) SCCamerFlashMode flashMode;

/// 对焦点
@property (nonatomic) CGPoint focusPoint;

/// 通过调整教具来实现视图放大缩小效果  最小是1
@property (nonatomic) CGFloat videoScale;


/**
 获取实例
 */
+ (SCCamerManager *)shareManager;

/**
 拍照
 */
- (void)takePhotoWithCompletion:(TakePhotoResult)completion;

/**
 录制
 */
- (void)recordVideo;


/// 结束录制视频
/// @param completion 完成回调
- (void)stopRecordVideoWithCompletion:(RecordVdieoResult)completion;


/// 添加图像输出的控件,不会被持有
- (void)addOutputView:(GPUImageView *)outputView;

/**
    开启相机 ,开启钱确保设置了outputView
 */
- (void)startCapaturing;

/**
 切换摄像头
 */
- (void)rotateCamera;

/**
    如果是常量,则会关闭闪光灯,但不会修改flashMode
 */
- (void)closeFlashIfNeed;

/**
刷新闪光灯
 */
- (void)updateFlashMode;

/**
 将缩放倍数转化到可用的范围
 */
- (CGFloat)availableVideoScaleWithScale:(CGFloat)scale;

/**
 正在录制的视频的时长
 */
- (NSTimeInterval)currenDuration;

@end

NS_ASSUME_NONNULL_END
