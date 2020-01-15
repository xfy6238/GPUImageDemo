//
//  SCCamerController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCamerController.h"
#import "SCCamerController+Private.h"

#import "SCPhotoResultViewController.h"
#import "SCVideoResultViewController.h"

//MARK: 处理编译器警告
//push 开始进入
#pragma clang diagnostic push
//方法弃用警告
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@interface SCCamerController ()

@end

@implementation SCCamerController

- (void)dealloc {
    [self removeObserver];
    [self endVideoTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
 
    SCCamerManager *cameraManager = [SCCamerManager shareManager];
    [cameraManager addOutputView:self.camerView];
    [cameraManager startCapaturing];
    
    [self updateDarkOrNormalModeWithRatio:cameraManager.ratio];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[SCCamerManager shareManager] updateFlashMode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SCCamerManager shareManager] closeFlashIfNeed];
}

- (void)commonInit {
    [self setupData];
    [self setupUI];
    [self setupTap];
    [self addObserver];
}

- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)setupData {
    self.videos = @[].mutableCopy;
    self.currentVideocale = 1.0;
}

- (void)forwardToPhotoResultWithImage:(UIImage *)image {
    SCPhotoResultViewController *con = [[SCPhotoResultViewController alloc]init];
    con.resultImage = image;
    [self.navigationController pushViewController:con animated:NO];
}

- (void)forwardToVideoResult {
    SCVideoResultViewController *con =  [[SCVideoResultViewController alloc]init];
    con.videos = self.videos;
    [self.navigationController pushViewController:con animated:YES];
}


//MARK: Custom Accessor
- (NSArray <SCFilterMaterialModel *> *)defaultFilterMaterias {
    if (!_defaultFilterMaterias) {
        _defaultFilterMaterias = [[SCFilterManager shareManager] defaultFilters];
    }
    return _defaultFilterMaterias;
}

- (NSArray<SCFilterMaterialModel *> *)tiktokFilterMaterias {
    if (!_tiktokFilterMaterias) {
        _tiktokFilterMaterias = [[SCFilterManager shareManager] tiktokFilters];
    }
    return _tiktokFilterMaterias;
}


//MARK: Action

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    
    [self setFilteBarViewHidden:YES animated:YES completion:NULL];
    [self refreshUIWhenFilterBarShowOrHide];
    
}

- (void)cameraViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.filterBarView.showing) {
        [self tapAction:nil];
        return;
    }
    
    CGPoint location = [tap locationInView:self.camerView];
    [[SCCamerManager shareManager] setFocusPoint:location];
    [self showFocusViewAtLocation:location];
}

//显示 滤镜选择 列表视图
- (void)filterAction:(id)sender {
    [self setFilteBarViewHidden:NO animated:YES completion:NULL];
    [self refreshUIWhenFilterBarShowOrHide];
    
    if (!self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterias;
    }
}

- (void)nextAction:(UIButton *)sender {
    [self forwardToVideoResult];
    [self refreshUIWhenRecordVideo];
}


//MARK: SCCapatureButtonDelegate
- (void)capturingButotnDidClicked:(SSCapturingButton *)button{
    if ((self.modeSwitchView.type == SCCapturingModeSwitchTypeImage)) {
        @weakify(self);
        
        [[SCCamerManager shareManager] takePhotoWithCompletion:^(UIImage *resultImage, NSError *error) {
            @strongify(self);
            [self forwardToPhotoResultWithImage: resultImage];
        }];
        
    } else if(self.modeSwitchView.type == SCCapturingModeSwitchTypeVideo) {
        if (self.isRecordingVideo) {
            [self stopRecordVideo];
        }else {
            [self startRecordVideo];
        }
    }
}


- (void)camerTopviewDidClickCloseButton:(SCCamerTopView *)cameraTopView {
    [self.videos removeAllObjects];
    [self refreshUIWhenRecordVideo];
}
//MARK: SCCapturingModeSwitchViewDelegate
- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view didChangeToType:(SCCapturingModeSwitchType)type{
  
}

//MARK: UIGestureReconizerDelegate
//controller的view上添加了一个手势, 在view上添加一个collectionview,会引起手势冲突,collectionview上select方法不执行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.filterBarView]) {
        return NO;
    }
    return YES;
}


//MARK: SCFilterBarviewDeleagte
//滤镜/美颜选择
//美颜
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn {
    if(isOn) {
        [self addBeautifyFilter];
    } else {
        [self removeBeautifyFiter];
    }
}

///美颜级别
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value {
    [SCCamerManager shareManager].currentFilterHadle.beautifyFilterDegree = value;
    
    
    
}

///使用内置滤镜/抖音滤镜
- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollviewToIndex:(NSUInteger)index {
    if (index == 0 && !self.filterBarView.defaultFilterMaterials) {
        self.filterBarView.defaultFilterMaterials = self.defaultFilterMaterias;
    } else if (index == 1 && !self.filterBarView.tiktokFilterMaterials){
        self.filterBarView.tiktokFilterMaterials = self.tiktokFilterMaterias;
    }
}

///具体滤镜选择
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollViewToIndex:(NSUInteger)index {
    NSArray<SCFilterMaterialModel *> *models = [self filterWithCategoryIndex:self.filterBarView.currentCategoryIndex];
    SCFilterMaterialModel *model = models[index];
    [[SCCamerManager shareManager].currentFilterHadle setEffectFilter:[[SCFilterManager shareManager] filerWithFilterID:model.filterID]];
    
}


@end
#pragma clang diagnostic pop
