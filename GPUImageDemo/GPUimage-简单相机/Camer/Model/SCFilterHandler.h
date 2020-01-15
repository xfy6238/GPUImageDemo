//
//  SCFilterHandler.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCFilterHandler : NSObject

///设置美颜滤镜是否可用
@property (nonatomic) BOOL beautifyFilterEnable;

///美颜滤镜程度 0~1 默认0.5 当beautifyFilterEnable为YES时,生效
@property (nonatomic) CGFloat beautifyFilterDegree;

///滤镜链源头
@property (nonatomic,weak) GPUImageOutput *source;

///滤镜链第一个滤镜
- (GPUImageFilter *)firstFilter;

//滤镜链最后一个滤镜
- (GPUImageFilter *)lastFilter;

//设置裁剪比例,用于设置特殊的相机比例
- (void)setCropRect:(CGRect)rect;

///往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter;

///设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter;

@end

NS_ASSUME_NONNULL_END
