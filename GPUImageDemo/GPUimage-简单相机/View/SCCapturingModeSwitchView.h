//
//  SCCapturingModeSwitchView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/10.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SCCapturingModeSwitchType) {
    SCCapturingModeSwitchTypeImage,
    SCCapturingModeSwitchTypeVideo
};

@class SCCapturingModeSwitchView;

@protocol SCCapturingModeSwitchViewDelegate <NSObject>

- (void)capturingModeSwitchView:(SCCapturingModeSwitchView *)view didChangeToType:(SCCapturingModeSwitchType)type;

@end

@interface SCCapturingModeSwitchView : UIView

@property (nonatomic, readonly) SCCapturingModeSwitchType type;

@property (nonatomic) BOOL isDarkMode;

@property (nonatomic, weak) id <SCCapturingModeSwitchViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
