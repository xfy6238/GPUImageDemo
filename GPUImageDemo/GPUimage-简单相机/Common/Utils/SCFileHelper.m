//
//  SCFileHelper.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/6.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFileHelper.h"

@implementation SCFileHelper

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)filePathInTmpWithName:(NSString *)name {
    return [[self temporaryDirectory] stringByAppendingPathComponent:name];
}

+ (NSString *)randomFilePathInTmpWithSuffix:(NSString *)suffix {
    long random = [[NSDate date] timeIntervalSince1970] *1000;
    return [[self filePathInTmpWithName:[NSString stringWithFormat:@"%ld",random]] stringByAppendingString:suffix];
}
@end
