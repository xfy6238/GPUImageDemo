//
//  SCFilterManager.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
#import "SCFilterMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCFilterManager : NSObject

///GPUimage 自动l滤镜列表
@property (nonatomic, strong, readonly) NSArray <SCFilterMaterialModel *> *defaultFilters;

///抖音了滤镜列表
@property (nonatomic, strong, readonly) NSArray <SCFilterMaterialModel *> *tiktokFilters;


/**
 获取实例
 */
+ (SCFilterManager *)shareManager;

/**
 通过滤镜ID 返回滤镜对象
 */

- (GPUImageFilter *)filerWithFilterID:(NSString *)filterID;



@end

NS_ASSUME_NONNULL_END
