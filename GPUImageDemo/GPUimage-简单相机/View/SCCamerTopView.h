//
//  SCCamerTopView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/10.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class SCCamerTopView;
@protocol SCCamerTopViewDelegate <NSObject>

- (void)camerTopViewDidClickRotateButton:(SCCamerTopView *)cameraTopView;
- (void)camerTopviewDidClickFlashButton:(SCCamerTopView *)cameraTopView;
- (void)camerTopviewDidClickRatioButton:(SCCamerTopView *)cameraTopView;
- (void)camerTopviewDidClickCloseButton:(SCCamerTopView *)cameraTopView;

@end

@interface SCCamerTopView : UIView

@property (nonatomic, strong, readonly) UIButton *rotateButton;
@property (nonatomic, strong, readonly) UIButton *flashButton;
@property (nonatomic, strong, readonly) UIButton *ratioButton;
@property (nonatomic, strong, readonly) UIButton *closeButton;

@property (nonatomic, weak) id <SCCamerTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
