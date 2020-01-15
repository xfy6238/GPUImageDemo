//
//  SCVideoModel.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/7.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCVideoModel : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) AVURLAsset *asset;


@end

NS_ASSUME_NONNULL_END
