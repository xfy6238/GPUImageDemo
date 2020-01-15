//
//  UIButton+Extention.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extention)

///通过图片名称来设置图片, 会自动设置黑暗模式和正常模式
- (void)setEnableDarkWithImageName:(NSString *)name;

///设置黑暗模式和正常模式的图片
- (void)setDarkImage:(UIImage *)darkImage normalImage:(UIImage *)normalImage;

///设置是否黑暗模式
- (void)setIsDarkMode:(BOOL)isDarkMode;

@end

NS_ASSUME_NONNULL_END
