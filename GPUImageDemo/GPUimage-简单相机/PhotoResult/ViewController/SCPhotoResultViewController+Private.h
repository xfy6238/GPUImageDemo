//
//  SCPhotoResultViewController+Private.h
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/6.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import <GPUImage.h>

#import "SCCamerManager.h"
#import "SCPhotoResultViewController.h"

@interface SCPhotoResultViewController ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *backButton;

#pragma mark - Action

- (void)confirmAction:(id)sender;

- (void)backAction:(id)sender;

#pragma mark - UI

- (void)setupUI;

/// 刷新黑暗模式或正常模式
- (void)updateDarkOrNormalMode;

@end
