//
//  SimpleVideoController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/27.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SimpleVideoController.h"
#import <AVFoundation/AVFoundation.h>

@interface SimpleVideoController ()
@property(nonatomic,strong) AVPlayer *player;
@end

static const NSString *PlayerItemStatusContext;

@implementation SimpleVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSNotificationCenter *cen = [NSNotificationCenter defaultCenter];
    [cen addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    //监听线路变化
    [cen addObserver:self selector:@selector(handleRouterChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];

    
    [self createVideoPlayer];

}

//MARK: 文字转语音
- (void)textToAudio {
    AVSpeechSynthesizer *sy = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utt = [[AVSpeechUtterance alloc]initWithString:@"AVFoundation"];
    [sy speakUtterance:utt];
}

//MARK: 视频播放器
- (void)createVideoPlayer {
//  获取路径
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"MP4"];

//  通过路径获取资源
    AVAsset *asset = [AVAsset assetWithURL:URL];
    
// 创建AVPlayerItem 建立资源动态视角的数据模型
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
//  观察statu的AVPlayerStatus类型属,检测播放对象状态
    self.player = [AVPlayer playerWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:0 context:&PlayerItemStatusContext];

    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 100, SCREEN_WIDTH, 300);
    [self.view.layer addSublayer:playerLayer];

    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        float currentTime = (double)self.player.currentItem.currentTime.value/self.player.currentItem.currentTime.timescale;
        float currentTime = (double)self.player.currentTime.value/self.player.currentTime.timescale;

        NSLog(@"当前播放进度: %f", currentTime);
    }];
}


//MARK: observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == &PlayerItemStatusContext) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [playerItem removeObserver:self forKeyPath:@"status" context:&PlayerItemStatusContext];
            
            CMTime duration = playerItem.duration;
            NSLog(@"视频总长: %.2f",CMTimeGetSeconds(duration));
            
            [self.player play];
        }
    }
}

//处理音频线路转换(耳机插拔)
- (void)handleRouterChange:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    //耳机断开
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //描述前一个线路
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        //找到第一个输出接口
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        //判断是否为耳机接口
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            
        }
    }
}

//处理打断状况
-(void)handleInterruption:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) { //被打断了
        //停止播放
    }else {//打断停止了
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        //音频会话重新激活
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            //开始播放
        }
        //继续播放
    }
}

-(void)dealloc {

  //要做一个判断,如果播放完成,移除通知中心
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

@end
