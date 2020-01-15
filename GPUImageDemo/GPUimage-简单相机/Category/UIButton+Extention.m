//
//  UIButton+Extention.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "UIButton+Extention.h"

#import <objc/runtime.h>

@implementation UIButton (Extention)

//MARK: Public

- (void)setEnableDarkWithImageName:(NSString *)name {
    NSString *darkName = [name stringByAppendingString:@"_black"];
    [self setDarkImage:[UIImage imageNamed:darkName] normalImage:[UIImage imageNamed:name]];
    [self setIsDarkMode:[self isDarkMode]];
}

- (void)setDarkImage:(UIImage *)darkImage normalImage:(UIImage *)normalImage {
    [self setDarkImage:darkImage];
    [self setNormalImage:normalImage];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    objc_setAssociatedObject(self, @selector(isDarkMode), @(isDarkMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImage *image = isDarkMode ? [self darkImage] : [self normalImage];
    [self setImage:image forState:UIControlStateNormal];
    
    if (isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefautlShadow];
    }
}

//MARK: Private

- (BOOL)isDarkMode {
    NSNumber *isDark = objc_getAssociatedObject(self, _cmd);
    return [isDark boolValue];
}

- (void)setDarkImage:(UIImage *)image {
    //存储image  key为@selector(darkImage);  也可以使用静态指针 static void * 类型的参数代替;但优先使用前一种方式,省略了声明参数的代码,保证了key的唯一性
    //存储了一个值 key为@selector(darkImage),value为image
    objc_setAssociatedObject(self, @selector(darkImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNormalImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(normalImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//normalImage  作为选择子
- (UIImage *)normalImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIImage *)darkImage {
    //取出存的值  _cmd 代指当前方法的选择子 即@selector(darkImage)
    return objc_getAssociatedObject(self, _cmd);
}


@end
