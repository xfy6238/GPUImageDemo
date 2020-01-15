//
//  SCAssetHelper.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/17.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCAssetHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation SCAssetHelper

+ (UIImage *)videoPreviewImageWithURL:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0.0, 600.0);
    NSError *error = nil;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:nil error:&error];
    
    if (error) {
        NSAssert(NO, error.description);
    }
    
    UIImage *videoImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return videoImage;
}


+ (void)mergeVideos:(NSArray *)videoPaths toExportPath:(NSString *)exportPath completion:(void (^)(void))completion {
    //混合工具
    AVComposition *composition = [self compsitionWithVideos:videoPaths];
    
    //导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = [NSURL fileURLWithPath:exportPath];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
    
}


//MARK: private
+ (AVComposition *)compsitionWithVideos:(NSArray *)videoPaths {
    return [self compositionWithVideos:videoPaths needAudioTracks:YES];
}

+ (AVComposition *)compositionWithVideos:(NSArray *)videoPaths needAudioTracks:(BOOL)needAudioTracks {
        
    AVMutableComposition *mergeComposition = [AVMutableComposition composition];
    CMTime time = kCMTimeZero;
    
    //视频轨道
    NSMutableArray *compositionVideoTracks = [NSMutableArray arrayWithCapacity:0];
    //往合成工具里加了一个视频轨道
    AVMutableCompositionTrack *compositionVideoTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTracks addObject:compositionVideoTrack];
    
    //音频轨道
    NSMutableArray *compositionAudioTracks = nil;
    if (needAudioTracks) {
        compositionAudioTracks = [NSMutableArray arrayWithCapacity:0];
        //往合成工具里添加了一个音频轨道
       AVMutableCompositionTrack *compositionAudioTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTracks addObject:compositionAudioTrack];
    }
    
    
    for (NSInteger index = 0; index< videoPaths.count; index ++) {
        NSString *videoPath = videoPaths[index];
        NSDictionary *inputOptions = @{AVURLAssetPreferPreciseDurationAndTimingKey : @(YES)};
        AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:videoPath] options:inputOptions];
        
        //得到asset的所有视频轨道
        NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        NSInteger videoDelta = [videoTracks count] - [compositionVideoTracks count];
        
        //资源的视频轨道大于合成工具里的轨道,继续往合成工具里添加足够的视频轨道
        if (videoDelta > 0) {
            for (NSInteger i = 0; i < videoDelta; i ++) {
                AVMutableCompositionTrack *insertCompositionVideoTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
                          
                          [compositionVideoTracks addObject:insertCompositionVideoTrack];
            }
          
        }
        
        for (int i = 0; i < videoTracks.count; i ++) {
            //资源文件里的视频轨道
            AVAssetTrack *videoTrack = [videoTracks objectAtIndex:i];
            //取出一个合成工具里的音轨
            AVMutableCompositionTrack *currentVideoCompositionTrack = [compositionVideoTracks objectAtIndex:i];
            
            //将asset的视频轨道 放入到合成工具里的视频轨道里
            [currentVideoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:time error:nil];
            if (index == 0) {
                [currentVideoCompositionTrack setPreferredTransform:videoTrack.preferredTransform];
            }
        }
        
        //处理音轨
        if (needAudioTracks) {
            NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
            NSInteger audioDelta = [audioTracks count] - [compositionAudioTracks count];
            if (audioDelta > 0) {
                for (int i = 0; i < audioDelta; i++) {
                    AVMutableCompositionTrack *insertCompositionAudioTrack = [mergeComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                    [compositionAudioTracks addObject:insertCompositionAudioTrack];
                }
            }
            
            for (int i = 0; i < audioTracks.count; i ++) {
                AVAssetTrack *audioTrack = [audioTracks objectAtIndex:i];
                AVMutableCompositionTrack *currentAudioCompositionTrack = [compositionAudioTracks objectAtIndex:i];
                [currentAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:time error:nil];
            }
        }
        time = CMTimeAdd(time, asset.duration);
    }
    return mergeComposition;
}


@end
