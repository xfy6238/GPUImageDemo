//
//  QuartzView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/27.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "QuartzView.h"

@implementation QuartzView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, 100);
    CGContextAddLineToPoint(context, 100, 300);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextStrokePath(context);
}


@end
