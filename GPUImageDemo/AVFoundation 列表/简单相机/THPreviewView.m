//
//  THPreviewView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/28.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "THPreviewView.h"

@implementation THPreviewView

/**
        MARK:重写layerClass方法,可以自定义图层类型
 */

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

-(void)setSession:(AVCaptureSession *)session {
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:session];
}

- (AVCaptureSession*)session {
    return [(AVCaptureVideoPreviewLayer *)self.layer session];
}

/**

    支持该类定义的不同处理方法;
    该方法将屏幕坐标系上的触控点转为摄像头坐标系上的点
*/
- (CGPoint)capatureDevicePointForPoint:(CGPoint)point {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}

@end
