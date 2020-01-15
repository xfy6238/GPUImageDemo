//
//  SystemPhotoTool.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/5.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotoAblumModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) PHAsset *headImageAsset; //相册中的第一张照片
@property (strong, nonatomic) PHCollection *assetCollction; //相册集  通过该属性获得该相册集下的所有照片

@end


@interface SystemPhotoTool : NSObject

+ (instancetype)sharePhotoTool;


/// 获取所有相册列表
- (NSArray<PhotoAblumModel *> *)getPhotoAblumList;

/// 获取相册中的所有图片资源
/// @param ascending  是否按照创建时间正序排列,YES : 正序排列
- (NSArray<PhotoAblumModel *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;


/// 获取指定相册中的所有图片
/// @param assetCollection 相册
/// @param ascending 是否按时间正序排列
- (NSArray <PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;


/**
    获取每个asset对应的图片
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size
                 resizeModel:(PHImageRequestOptionsResizeMode)resizeModel
                  completion:(void(^)(UIImage *image))completion;

/// 删除系统相册中的照片 单个或多个
/// @param assets 要删除的照片数组
/// @param completionHandle 成功的回调
- (void)deleteSystemPhotoWithPhotos:(NSArray<PHAsset *>*)assets successHandle:(dispatch_block_t)completionHandle;

#pragma mark 判断软件是否有相册访问权限
+ (BOOL)judgeIsHavePhotoAblumAuthority;

#pragma mark 判断软件是否有相机访问权限
+ (BOOL)judgeIsHaveCamerAuthoruity;
@end

NS_ASSUME_NONNULL_END
