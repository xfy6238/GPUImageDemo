//
//  SCFilterHelper.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface SCFilterHelper : NSObject

/// 给图片上滤镜效果
/// @param filter 滤镜
/// @param originImage 原图
+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter originImage:(UIImage *)originImage;

@end

NS_ASSUME_NONNULL_END
