//
//  SCCamerController+Noticfication.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCamerController+Noticfication.h"
#import "SCCamerController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


@implementation SCCamerController (Noticfication)

- (void)addObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didEnterBackground:(NSNotification *)notice {
    [self stopRecordVideo];
}

- (void)willResignActive:(NSNotification *)notice {
    [self stopRecordVideo];
}


@end
#pragma clang diagnostic pop
