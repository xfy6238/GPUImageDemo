//
//  SCAssetHelper.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/17.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCAssetHelper : NSObject

///获取视频第一帧
+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url;

///合并视频
+ (void)mergeVideos:(NSArray *)videoPaths toExportPath:(NSString *)exportPath completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
