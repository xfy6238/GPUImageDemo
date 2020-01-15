//
//  UIDevice+Extention.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/10.
//  Copyright © 2019 xufuyang. All rights reserved.
//



#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,DeviceType) {
    Unknown = 0,
    Simulator,
    IPhone_1G,
    IPhone_3G,
    IPhone_3GS,
    IPhone_4,
    IPhone_4s,
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
    IPhone_XR,
    IPhone_XS,
    IPhone_XS_Max,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extention)

+ (DeviceType)deviceType;

+ (BOOL)is_iPhoneX_Series;
@end

NS_ASSUME_NONNULL_END
