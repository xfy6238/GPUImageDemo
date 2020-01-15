//
//  SCCamerController+Private.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <GPUImage.h>
#import "SCCamerController.h"

#import "SSCapturingButton.h"
#import "SCCameraVideoTimeLabel.h"
#import "SCFilterBarView.h"
#import "SCCamerTopView.h"
#import "SCCapturingModeSwitchView.h"
#import "SCVisualEffectView.h"

#import "SCCamerManager.h"
#import "SCFilterManager.h"

#import "SCVideoModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCCamerController () <

    UIGestureRecognizerDelegate,
    SCCapturingButtonDelegate,
    SCFilterBarViewDelegate,
    SCCamerTopViewDelegate,
    SCCapturingModeSwitchViewDelegate
>

@property (nonatomic, strong) GPUImageView *camerView;

@property (nonatomic, strong) SCCameraVideoTimeLabel *videoTimeLab;

@property (nonatomic, strong) SSCapturingButton *capturingButton;
@property (nonatomic, strong) SCFilterBarView *filterBarView;
@property (nonatomic, strong) SCCamerTopView *cameraTopView;
@property (nonatomic, strong) SCCapturingModeSwitchView *modeSwitchView;
@property (nonatomic, strong) UIView *cameraFocusView; //聚焦框
@property (nonatomic, strong) SCVisualEffectView *ratioBlurView;  // 切换比例的时候的模糊蒙层


@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *nextButton;


@property (nonatomic, assign) BOOL isRecordingVideo;  // 是否正在录制视频
@property (nonatomic) BOOL isChangingRatio; //是否正在改变比例


@property (nonatomic, strong) NSMutableArray <SCVideoModel *> *videos;

@property (nonatomic, assign) CGFloat currentVideocale;


@property (nonatomic, strong) NSTimer *videoTimer; //用于刷新录屏中的时间

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterias;
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tiktokFilterMaterias;

//MARK: UI
- (void)setupUI;

//录制视频时  刷新UI
- (void)refreshUIWhenRecordVideo;

//刷新黑暗模式或正常模式
- (void)updateDarkOrNormalModeWithRatio:(SCCamerRatio)ratio;

///在滤镜栏显示或隐藏的时候 刷新UI
- (void)refreshUIWhenFilterBarShowOrHide;

///显示聚焦框
- (void)showFocusViewAtLocation:(CGPoint)point;

//MARK:设置滤镜栏显示或隐藏
- (void)setFilteBarViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void(^)(void))completion;

//MARK: RecordVideo
- (void)startRecordVideo;

- (void)stopRecordVideo;

- (void)startVideoTimer;

- (void)endVideoTimer;


//MARK: Filter
///添加美颜滤镜
- (void)addBeautifyFilter;

///移除滤镜
- (void)removeBeautifyFiter;


///根据分类索引, 获取滤镜列表
- (NSArray<SCFilterMaterialModel *> *)filterWithCategoryIndex:(NSInteger)index;


//MARK:Notification

/**
    添加监听
 */
- (void)addObserver;
/**
移除监听
 */
- (void)removeObserver;

@end

NS_ASSUME_NONNULL_END
