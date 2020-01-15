//
//  SCFilterCategoryCell.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterCategoryCell.h"

static NSInteger kFilterCategoryCellBottomLineHeight = 2;

@implementation SCFilterCategoryCell

- (instancetype)init {
    self = [super init];
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _titleLab = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kFilterCategoryCellBottomLineHeight, 0, kFilterCategoryCellBottomLineHeight)];
    _bottomLine.clipsToBounds = YES;
    _bottomLine.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLab.frame = self.bounds;
    
    CGRect bottomLineFrame = _bottomLine.frame;
    bottomLineFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(bottomLineFrame)) / 2;
    bottomLineFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(bottomLineFrame);
    _bottomLine.frame = bottomLineFrame;
}


@end
