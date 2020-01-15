//
//  SCCamerController+RecordVideo.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCamerController+RecordVideo.h"

#import "SCCamerController+Private.h"
#import "LFGPUImageBeautyFilter.h"
#import "SCCamerController+UI.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


@implementation SCCamerController (RecordVideo)

- (void)startRecordVideo {
    if (self.isRecordingVideo) {
        return;
    }
    self.capturingButton.capturingState = SCCapturingButtonStateRecording;
    self.isRecordingVideo = YES;
    
    [[SCCamerManager shareManager] recordVideo];
    [self startVideoTimer];
    
    [self refreshUIWhenRecordVideo];
}

- (void)stopRecordVideo {
    if (!self.isRecordingVideo) {
        return;
    }
    self.capturingButton.capturingState = SCCapturingButtonStateNormal;
    @weakify(self);
    [[SCCamerManager shareManager] stopRecordVideoWithCompletion:^(NSString *videoPath) {
        @strongify(self);
        
        self.isRecordingVideo = NO;
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
        SCVideoModel *videoModel = [SCVideoModel new];
        videoModel.filePath = videoPath;
        videoModel.asset = asset;
        [self.videos addObject:videoModel];
        
        [self endVideoTimer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUIWhenRecordVideo];
        });
    }];
}


- (void)startVideoTimer {
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(videoTimerAction) userInfo:nil repeats:YES];
    [self.videoTimer fire];
}

- (void)endVideoTimer {
    [self.videoTimer invalidate];
    self.videoTimer = nil;
}

//MARK: Action

- (void)videoTimerAction {
    CMTime savedTime = kCMTimeZero;
    for (SCVideoModel *model in self.videos) {
        savedTime = CMTimeAdd(savedTime, model.asset.duration);
        NSLog(@"前一个视频的是时长: %f",CMTimeGetSeconds(savedTime));
    }
    NSInteger timeStamp = round(CMTimeGetSeconds(savedTime) + [SCCamerManager shareManager].currenDuration);
    self.videoTimeLab.timestamp = timeStamp;
}


@end
#pragma clang diagnostic pop
