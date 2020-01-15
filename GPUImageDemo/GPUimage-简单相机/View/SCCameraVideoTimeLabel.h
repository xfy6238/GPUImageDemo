//
//  SCCameraVideoTimeLabel.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/7.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCameraVideoTimeLabel : UIView

@property (nonatomic) NSInteger timestamp;
@property (nonatomic) BOOL isDarkMode;

///重置时间
- (void)resetTime;

@end

NS_ASSUME_NONNULL_END
