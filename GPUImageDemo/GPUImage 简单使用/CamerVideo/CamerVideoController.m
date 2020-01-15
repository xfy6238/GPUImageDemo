//
//  CamerVideoController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/11.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "CamerVideoController.h"
#import <GPUImageView.h>
#import <GPUImageVideoCamera.h>
#import <GPUImageSepiaFilter.h>

@interface CamerVideoController ()

@property (nonatomic,strong) GPUImageView *mGPUImageView;
@property (nonatomic,strong) GPUImageVideoCamera *mGPUVideoCamer;

@end

@implementation CamerVideoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _mGPUVideoCamer = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _mGPUImageView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _mGPUImageView.fillMode = kGPUImageFillModeStretch;
    [self.view addSubview:_mGPUImageView];
    
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc]init];
    [_mGPUVideoCamer addTarget:filter];
    [filter addTarget:_mGPUImageView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_mGPUVideoCamer startCameraCapture];
    });
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation) [UIDevice currentDevice].orientation;
    _mGPUVideoCamer.outputImageOrientation = orientation;
}




@end
