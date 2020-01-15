//
//  SSGPUImageBaseFilter.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "GPUImageFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSGPUImageBaseFilter : GPUImageFilter

@property (nonatomic) GLint timeUniform;
@property (nonatomic) CGFloat time;

//滤镜开始应用的时间
@property (nonatomic) CGFloat beginTime;

@end

NS_ASSUME_NONNULL_END
