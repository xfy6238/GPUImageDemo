//
//  SCTimerHelper.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/7.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCTimerHelper.h"

@implementation SCTimerHelper

+ (NSString *)timeStringWithTimestamp:(NSInteger)timestamp {
    NSInteger second = timestamp % 60;
    NSInteger minute = (timestamp / 60) % 60;
    NSInteger hour = timestamp / 60 / 60;
    
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    if (hour > 0) {
        result = [NSString stringWithFormat:@"%02ld:%@",hour, result];
    }
    return result;
}

@end
