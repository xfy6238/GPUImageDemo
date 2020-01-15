//
//  QuartzController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/27.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "QuartzController.h"
#import "QuartzView.h"

@implementation QuartzController

- (void)viewDidLoad {
    UIView *view1 = [[QuartzView alloc]init];
    view1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view1.center = self.view.center;
    [self.view addSubview:view1];
}


@end
