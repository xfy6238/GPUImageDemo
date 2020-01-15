//
//  SimpleController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/11.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SimpleController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface SimpleController ()

@property (strong,nonatomic) GPUImageStillCamera *mCamer;

@property (strong,nonatomic) GPUImageFilter *mFliter;
//反色滤镜
@property (strong,nonatomic) GPUImageColorInvertFilter *invertFliter;
//伽马线滤镜
@property (strong,nonatomic) GPUImageGammaFilter *gammaFliter;
//曝光度滤镜
@property (strong,nonatomic) GPUImageExposureFilter *exposureFliter;
//怀旧滤镜
@property (strong,nonatomic) GPUImageSepiaFilter *sepiaFliter;

@property (strong,nonatomic) GPUImageFilterGroup *filterGroup;

@property (weak, nonatomic) IBOutlet GPUImageView *mGPUImageView;

@property (weak, nonatomic) IBOutlet UIButton *camerButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SimpleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _mCamer =  [[GPUImageStillCamera alloc] init];
    _mCamer.outputImageOrientation = UIInterfaceOrientationPortrait;
    [self.view addSubview:_mGPUImageView];
        
    [self segmentAction:_segmentControl];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mCamer startCameraCapture];
        [self.mCamer addAudioInputsAndOutputs];
    });

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}

//MARK: 使用这个方法进行照片拍摄,直接对照片进行操作, 把图片的方向属性给清除掉了,所以图片向右旋转了90度
- (IBAction)takePhoto:(UIButton *)sender {
    [_mCamer capturePhotoAsJPEGProcessedUpToFilter:_mFliter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        //将照片保存到手机相册
        UIImage *image = [UIImage imageWithData:processedJPEG];
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSaveingWithError:contextInfo:), nil);
        }
        
    }];
}
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
 
    switch (index) {
        case 0:{ //单一滤镜
            if (!_mFliter) {
                _mFliter = [[GPUImageStretchDistortionFilter alloc]init];
            }
            [_mCamer removeAllTargets];
            
            [_mCamer addTarget:_mFliter];
            [_mFliter addTarget:_mGPUImageView];
        }
            break;
        case 1:
            [_mCamer removeAllTargets];
            
            if (!_invertFliter) {
                _invertFliter = [GPUImageColorInvertFilter new];
            }
            if (!_gammaFliter) {
                _gammaFliter = [GPUImageGammaFilter new];
            }
            if (!_exposureFliter) {
                _exposureFliter = [GPUImageExposureFilter new];
            }
            if (!_sepiaFliter) {
                _sepiaFliter = [GPUImageSepiaFilter new];
            }
            
            if (!_filterGroup) {
                _filterGroup = [GPUImageFilterGroup new];
                [self addGPUImageFilter:_invertFliter];
                [self addGPUImageFilter:_gammaFliter];
                [self addGPUImageFilter:_exposureFliter];
                [self addGPUImageFilter:_sepiaFliter];
            }
            
            [_mCamer addTarget:_filterGroup];
            //将滤镜加载filterGroup中
            [self.filterGroup addTarget:self.mGPUImageView];
            break;
    }
}

//MARK: 往滤镜组中添加滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter {
    [self.filterGroup addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTeriminalFilter  = filter;
    NSInteger count = self.filterGroup.filterCount;
    
    if (count == 1) {
        //设置初始滤镜
        self.filterGroup.initialFilters = @[newTeriminalFilter];
        //设置末尾滤镜
        self.filterGroup.terminalFilter = newTeriminalFilter;
    }else{
        GPUImageOutput<GPUImageInput> *terminalFilter = self.filterGroup.terminalFilter;
        NSArray *initalFilters                        = self.filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTeriminalFilter];
        
        //设置初始滤镜
        self.filterGroup.initialFilters = @[initalFilters[0]];
        //设置末尾滤镜
        self.filterGroup.terminalFilter = newTeriminalFilter;
    }
}



- (void)image:(UIImage *)image didFinishSaveingWithError:(NSError *)error contextInfo:(void *)info {
    if (!error) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}


//MARK: 设置UI

- (void)setupUI {
    
    _camerButton.layer.borderColor = [UIColor redColor].CGColor;
    _camerButton.layer.borderWidth = 5.0;
    
    _camerButton.layer.cornerRadius = 30;
    
}

- (void)dealloc {
    [self.mCamer stopCameraCapture];
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}
@end
