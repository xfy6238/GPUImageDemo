//
//  SCTimerHelper.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/7.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTimerHelper : NSObject

///将时间戳转化为 12:59:59 格式
+ (NSString *)timeStringWithTimestamp:(NSInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
