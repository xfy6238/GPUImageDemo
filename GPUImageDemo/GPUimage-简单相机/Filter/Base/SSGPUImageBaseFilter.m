//
//  SSGPUImageBaseFilter.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SSGPUImageBaseFilter.h"

@implementation SSGPUImageBaseFilter


 - (id)initWithVertexShaderFromString:(NSString *)vertexShaderString
             fragmentShaderFromString:(NSString *)fragmentShaderString {
     self = [super initWithVertexShaderFromString:vertexShaderString fragmentShaderFromString:fragmentShaderString];
     
     //找到time 属性的索引值
     self.timeUniform = [filterProgram uniformIndex:@"time"];
     self.time = 0.0f;
     
     return self;
 }

- (void)setTime:(CGFloat)time {
    _time = time;
    [self setFloat:time forUniform:self.timeUniform program:filterProgram];
}

@end
