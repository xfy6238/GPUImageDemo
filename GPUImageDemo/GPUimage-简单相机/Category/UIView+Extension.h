//
//  UIView+Extension.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)


/**
 设置显示隐藏
 */

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 设置阴影
 */
- (void)setShadowWithColor:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset;

/**
设置默认阴影
 */
- (void)setDefautlShadow;

/**
 清除阴影
 */
- (void)clearShadow;

@end

NS_ASSUME_NONNULL_END
