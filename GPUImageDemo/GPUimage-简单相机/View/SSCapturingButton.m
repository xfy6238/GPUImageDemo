//
//  SSCapturingButton.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/1.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SSCapturingButton.h"
#import <Masonry.h>


@interface SSCapturingButton ()

//录制视频暂停控件
@property (nonatomic, strong) UIView *recordStopView;

@end

@implementation SSCapturingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commInit];
    }
    return self;
}

//MARK: private

- (void)commInit {
    self.capturingState = SCCapturingButtonStateNormal;
    [self setUI];
    [self addAction];
}

- (void)setUI{
    [self setImage:[UIImage imageNamed:@"btn_capture"] forState:UIControlStateNormal];
    [self setupRecordStopView];
}

- (void)setupRecordStopView {
    self.recordStopView = [UIView new];
    self.recordStopView.userInteractionEnabled = NO;
    self.recordStopView.alpha = 0;
    self.recordStopView.layer.cornerRadius = 5;
    self.recordStopView.backgroundColor = ThemeColor;
    [self addSubview:self.recordStopView];
    [self.recordStopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)addAction {
    [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: Custom Accessor
- (void)setCapturingState:(SCCapturingButtonState)capturingState {
    _capturingState = capturingState;
    [self.recordStopView setHidden:capturingState == SCCapturingButtonStateNormal animated:YES completion:nil];
}


//MARK: Actions
- (void)touchUpInsideAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(capturingButotnDidClicked:)]) {
        [self.delegate capturingButotnDidClicked:btn];
    }
}


@end
