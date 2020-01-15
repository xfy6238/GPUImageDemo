//
//  SCFilterHelper.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterHelper.h"

@implementation SCFilterHelper
+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter originImage:(UIImage *)originImage {
    [filter forceProcessingAtSize:originImage.size];
    GPUImagePicture *picture = [[GPUImagePicture alloc]init];
    [picture addTarget:filter];
    
    [picture processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}
@end
