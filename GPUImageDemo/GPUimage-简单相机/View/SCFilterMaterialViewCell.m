//
//  SCFilterMaterialViewCell.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterMaterialViewCell.h"

#import "SSGPUImageBaseFilter.h"
#import "SCFilterManager.h"
#import "SCFilterHelper.h"

@interface SCFilterMaterialViewCell ()

@property (nonatomic, strong) GPUImageView *imaeView;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) GPUImagePicture *picture;

@property (nonatomic, strong) UIView *selectView;

@end

@implementation SCFilterMaterialViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.picture removeAllTargets];
    self.selectView.hidden = YES;
}

//MARK: Private

- (void)commonInit {
    [self setUpImageView];
    [self setupTitleLab];
    [self setupSelctView];
    
    self.picture = [[GPUImagePicture alloc]initWithImage:[UIImage imageNamed:@"filter_sample.jpg"]];

}

- (void)setUpImageView {
    self.imaeView = [[GPUImageView alloc]init];
     [self addSubview:self.imaeView];
     [self.imaeView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(60, 80));
         make.centerX.equalTo(self);
         make.top.mas_equalTo(self);
     }];
}

- (void)setupTitleLab {
    self.titleLab = [UILabel new];
    self.titleLab.font = [UIFont systemFontOfSize:12];
    self.titleLab.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setupSelctView {
    self.selectView = [UIView new];
    self.selectView.hidden = YES;
    self.selectView.backgroundColor = ThemeColorA(0.8);
    [self addSubview:self.selectView];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imaeView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_select"]];
    [self.selectView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.selectView);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}

//MARK: Custom Accessor
- (void)setFilterMaterialModel:(SCFilterMaterialModel *)filterMaterialModel {
    _filterMaterialModel = filterMaterialModel;

    self.titleLab.text = filterMaterialModel.filterName;
    GPUImageFilter *filter = [[SCFilterManager shareManager] filerWithFilterID:filterMaterialModel.filterID];
    if ([filter isKindOfClass:[SSGPUImageBaseFilter class]]) {
        ( (SSGPUImageBaseFilter *)filter).time = 0.2f;
    }
    [self.picture addTarget:filter];
    [filter addTarget:self.imaeView];
    
    if (!self.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.picture processImage];
        }) ;
    }else{
        [self.picture processImage];
    }
}

- (void)setSelected:(BOOL)selected {
    _isSelect = selected;
    
    self.selectView.hidden = !selected;
    self.titleLab.textColor = selected ? ThemeColor : [UIColor whiteColor];
}

@end
