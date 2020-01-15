//
//  SCCapturingModeSwitchView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/10.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCapturingModeSwitchView.h"

@interface SCCapturingModeSwitchView ()

@property (nonatomic, readwrite) SCCapturingModeSwitchType type;
@property (nonatomic, strong) UILabel *imageLab;
@property (nonatomic, strong) UILabel *videoLab;

@end

@implementation SCCapturingModeSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

//MARK: Custom Accessor

- (void)setIsDarkMode:(BOOL)isDarkMode {
    _isDarkMode = isDarkMode;
    [self updtaeDarkMode];
}

//MARK: Private
- (void)commonInit {
    [self setupImageLabel];
    [self setupVideoLabel];
    [self updtaeDarkMode];
}

- (void)setupImageLabel {
    self.imageLab = [UILabel new];
    self.imageLab.text = @"拍照";
    self.imageLab.textAlignment = NSTextAlignmentCenter;
    self.imageLab.userInteractionEnabled = YES;
    self.imageLab.textColor = [UIColor whiteColor];
    self.imageLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.imageLab];
    [self.imageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction)];
    [self.imageLab addGestureRecognizer:tap];
}

- (void)setupVideoLabel {
    self.videoLab = [UILabel new];
    self.videoLab.text = @"录制";
    self.videoLab.textAlignment = NSTextAlignmentCenter;
    self.videoLab.userInteractionEnabled = YES;
    self.videoLab.textColor = RGBA(255, 255, 255, 0.6);
    self.videoLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.videoLab];
    [self.videoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoTapAction)];
    [self.videoLab addGestureRecognizer:tap];
}

- (void)selectType:(SCCapturingModeSwitchType)type {
    if (self.type == type) {
        return;
    }
    self.type = type;
    UILabel *selectLab = nil;
    UILabel *normalLab = nil;
    if (self.type == SCCapturingModeSwitchTypeImage) {
        selectLab = self.imageLab;
        normalLab = self.videoLab;
    } else {
        selectLab = self.videoLab;
        normalLab = self.imageLab;
    }
    
    selectLab.font = [UIFont boldSystemFontOfSize:12];
    normalLab.font = [UIFont systemFontOfSize:12];
    [self updtaeDarkMode];
    [self.delegate capturingModeSwitchView:self didChangeToType:self.type];
}

- (void)updtaeDarkMode {
    UILabel *selectLab = nil;
    UILabel *normalLab = nil;
    if (self.type == SCCapturingModeSwitchTypeImage) {
        selectLab = self.imageLab;
        normalLab = self.videoLab;
    } else {
        selectLab = self.videoLab;
        normalLab = self.imageLab;
    }
    selectLab.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    normalLab.textColor = self.isDarkMode ? RGBA(0, 0, 0, 0.6) : RGBA(255, 255, 255, 0.6);
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefautlShadow];
    }
}

//MARK: Action
- (void)imageTapAction {
    [self selectType:SCCapturingModeSwitchTypeImage];
}

- (void)videoTapAction {
    [self selectType:SCCapturingModeSwitchTypeVideo];
}

@end
