//
//  SystemPhotoTool.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/5.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SystemPhotoTool.h"


@implementation PhotoAblumModel


@end

@implementation SystemPhotoTool

static SystemPhotoTool *sharePhotoTool = nil;
+ (instancetype)sharePhotoTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [[self alloc]init];
    });
    return sharePhotoTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [super allocWithZone:zone];
    });
    return sharePhotoTool;
}

- (NSArray <PhotoAblumModel *> *)getPhotoAblumList {
    NSMutableArray<PhotoAblumModel *> *photoAblumList = @[].mutableCopy;
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
       //过滤掉视频和最近删除
        if (![collection.localizedTitle isEqualToString:@"Recently Deleted"]) {
            NSArray <PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:YES];
            if (assets.count > 0) {
                PhotoAblumModel *model = [PhotoAblumModel new];
                model.title = [self transformAblumTitle:collection.localizedTitle];
                model.count = assets.count;
                model.headImageAsset = assets.firstObject;
                model.assetCollction = collection;
                [photoAblumList addObject:model];
            }
        }
    }];

    //获取用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            PhotoAblumModel *model = [PhotoAblumModel new];
            model.title = collection.localizedTitle;
            model.count = assets.count;
            model.headImageAsset = assets.firstObject;
            model.assetCollction = collection;
            [photoAblumList addObject:model];
        }
    }];
    return photoAblumList;
}

- (NSString *)transformAblumTitle:(NSString *)title{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    }
    if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    }
    if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    }
    if ([title isEqualToString:@"Recently Deleted"]){
        return @"最近删除";
    }
    if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    }
    if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    }
    if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    }
    if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    }
    if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    }
    return nil;
}

- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)asceding {
    PHFetchOptions *option = [PHFetchOptions new];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:asceding]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

//MARK: 获取指定相册内的所有照片
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    NSMutableArray<PHAsset *> *array = @[].mutableCopy;
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [array addObject:obj];
        }
    }];
    return array;
}

//MARK: 获取asset对应的图片
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeModel:(PHImageRequestOptionsResizeMode)resizeModel completion:(void (^)(UIImage * _Nonnull))completion {
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.resizeMode = resizeModel;
    options.networkAccessAllowed = YES;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
}


//MARK: 软件是否有相册访问权限
+ (BOOL)judgeIsHavePhotoAblumAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

//MARK: 判断软件是否有相机访问权限
+ (BOOL)judgeIsHaveCamerAuthoruity {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

@end
