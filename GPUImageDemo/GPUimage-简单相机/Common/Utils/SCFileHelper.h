//
//  SCFileHelper.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/6.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCFileHelper : NSObject
/**
 tmp 文件夹
 */
+ (NSString *)temporaryDirectory;

/**
 通过文件名返回tmp文件夹中的文件路径
 */
+ (NSString *)filePathInTmpWithName:(NSString *)name;

/**
 通过一个后缀, 返回tmp文件夹中的一个随机路径
 */
+ (NSString *)randomFilePathInTmpWithSuffix:(NSString *)suffix;
@end

NS_ASSUME_NONNULL_END
