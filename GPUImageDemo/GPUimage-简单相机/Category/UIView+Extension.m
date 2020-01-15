//
//  UIView+Extension.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion {
    CGFloat beginAlpha = self.alpha;
    CGFloat endAlpha = hidden ? 0 : 1;
    if (beginAlpha == endAlpha) {
        if (completion) {
            completion();
        }
        return;
    }
    
    if (!animated) {
        self.alpha = endAlpha;
        if (completion) {
            completion();
        }
        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = endAlpha;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}


- (void)setShadowWithColor:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = alpha;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}

- (void)setDefautlShadow {
    [self setShadowWithColor:RGBA(74, 74, 74, 1) alpha:0.4 radius:2.0 offset:CGSizeMake(0, 0)];
}

- (void)clearShadow {
    [self setShadowWithColor:[UIColor clearColor] alpha:0 radius:0 offset:CGSizeZero];
}

@end
