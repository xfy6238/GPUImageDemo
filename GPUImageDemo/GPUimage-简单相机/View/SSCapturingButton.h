//
//  SSCapturingButton.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SCCapturingButtonState) {
    SCCapturingButtonStateNormal,
    SCCapturingButtonStateRecording,
};

@class SSCapturingButton;

@protocol SCCapturingButtonDelegate <NSObject>


/**
    拍照按钮被点击
 
 */
- (void)capturingButotnDidClicked:(SSCapturingButton *)button;

@end

@interface SSCapturingButton : UIButton

@property (nonatomic, assign) SCCapturingButtonState capturingState;
@property (nonatomic, weak) id <SCCapturingButtonDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
