//
//  SCCameraVideoTimeLabel.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/7.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCCameraVideoTimeLabel.h"
#import "SCTimerHelper.h"

@interface SCCameraVideoTimeLabel ()

@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation SCCameraVideoTimeLabel


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


//MARK: Public

- (void)resetTime {
    self.timestamp = 0;
}

//MARK: Private

- (void)commonInit {
    [self setupTimeLabel];
    [self updateDarkMode];
    [self updateTimeLabel];
}

- (void)setupTimeLabel {
    self.timeLab = [UILabel new];
    self.timeLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)updateDarkMode {
    self.timeLab.textColor = self.isDarkMode ? [UIColor blackColor] : [UIColor whiteColor];
    
    if (self.isDarkMode) {
        [self clearShadow];
    } else {
        [self setDefautlShadow];
    }
}

- (void)updateTimeLabel {
    self.timeLab.text =  [SCTimerHelper timeStringWithTimestamp:self.timestamp];
    NSLog(@"当前时间 :%@",self.timeLab.text);
}

//MARK: Custom Accessor

- (void)setTimestamp:(NSInteger)timestamp {
    _timestamp = timestamp;
    
    [self updateTimeLabel];
}

- (void)setIsDarkMode:(BOOL)isDarkMode {
    _isDarkMode = isDarkMode;
    
    [self updateDarkMode];
}

@end
