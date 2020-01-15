//
//  THPreviewView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/28.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol  THPreviewViewDelegate <NSObject>
- (void)tappedToFoucesAtPoint:(CGPoint)point;
- (void)tappedToExposeAtPoint:(CGPoint)point;
- (void)tappedToResetFocusAndExposure;

@end

@interface THPreviewView : UIView

@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,weak) id<THPreviewViewDelegate>delegate;

@property (nonatomic) BOOL tapToFocusEnabled;
@property (nonatomic) BOOL tapToExposenabled;


@end

NS_ASSUME_NONNULL_END
