//
//  SCCamerTopView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/10.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCamerTopView.h"

@interface SCCamerTopView ()

@property (nonatomic, strong, readwrite) UIButton *rotateButton;
@property (nonatomic, strong, readwrite) UIButton *flashButton;
@property (nonatomic, strong, readwrite) UIButton *ratioButton;
@property (nonatomic, strong, readwrite) UIButton *closeButton;

@property (nonatomic) BOOL isRotating; //正在旋转中

@end

@implementation SCCamerTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

//MARK: Private
- (void)commonInit {
    [self setupRotateButton];
    [self setupFlashButton];
    [self setupRatioButton];
    [self setupCloseButton];
}

- (void)setupRotateButton {
    self.rotateButton = [UIButton new];
    [self addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.rotateButton addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton setEnableDarkWithImageName:@"btn_rotato"];
}

- (void)setupFlashButton {
    self.flashButton = [UIButton new];
    [self addSubview:self.flashButton];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.flashButton addTarget:self action:@selector(flashAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton setEnableDarkWithImageName:@"btn_flash_off"];
}

- (void)setupRatioButton {
    self.ratioButton = [UIButton new];
    [self addSubview:self.ratioButton];
    [self.ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.ratioButton addTarget:self action:@selector(ratioAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.ratioButton setEnableDarkWithImageName:@"btn_ratio_9v16"];
}

- (void)setupCloseButton {
    self.closeButton = [UIButton new];
    self.closeButton.alpha = 0;
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setEnableDarkWithImageName:@"btn_close"];
}

//MARK: Action
- (void)rotateAction:(UIButton *)sender {
    if (self.isRotating) {
        return;
    }
    self.isRotating = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.ratioButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        self.ratioButton.transform = CGAffineTransformIdentity;
        self.isRotating = NO;
    }];
    
    if ([self.delegate respondsToSelector:@selector(camerTopViewDidClickRotateButton:)]) {
        [self.delegate camerTopViewDidClickRotateButton:self];
    }
}

- (void)flashAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(camerTopviewDidClickFlashButton:)]) {
        [self.delegate camerTopviewDidClickFlashButton:self];
    }
}

- (void)ratioAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(camerTopViewDidClickRotateButton:)]) {
        [self.delegate camerTopviewDidClickRatioButton:self];
    }
}

- (void)closeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(camerTopviewDidClickCloseButton:)]) {
        [self.delegate camerTopviewDidClickCloseButton:self];
    }
}

@end
