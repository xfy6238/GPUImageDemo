//
//  SCFilterBarView.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterBarView.h"

#import "SCFilterMaterialView.h"
#import "SCFilterCategoryView.h"

static CGFloat const kFilterMaterialViewHeight = 100.0f;

@interface SCFilterBarView () <SCFilterMaterialViewDelegate,SCFilterCategoryViewDelegate>

@property (nonatomic, strong) SCFilterMaterialView *filterMaterialView;
@property (nonatomic, strong) SCFilterCategoryView *filterCategoryView;
@property (nonatomic, strong) UISwitch *beautifySwitch;
@property (nonatomic, strong) UISlider *beautyifySlider;

@end

@implementation SCFilterBarView

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

//MARK: Private
- (void)commonInit {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    [self setupFilterCategoryView];
    [self setupFilterMaterialView];
    [self setupBeautifySwitch];
    [self setupBeautiftySldier];
}

- (void)setupFilterCategoryView {
    self.filterCategoryView = [[SCFilterCategoryView alloc]init];
    self.filterCategoryView.delegate = self;
    self.filterCategoryView.itemNormalColor = [UIColor whiteColor];
    self.filterCategoryView.itemSelectColor = ThemeColor;
    self.filterCategoryView.itemList = @[@"内置",@"抖音"];
    self.filterCategoryView.itemFont = [UIFont systemFontOfSize:14];
    self.filterCategoryView.itemWidth = 65;
    self.filterCategoryView.bottomLineWidth = 30;
    [self addSubview:self.filterCategoryView];
    [self.filterCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(35);
    }];
}

- (void)setupFilterMaterialView {
    self.filterMaterialView = [[SCFilterMaterialView alloc] init];
    self.filterMaterialView.delegate = self;
    [self addSubview:self.filterMaterialView];
    [self.filterMaterialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.height.mas_equalTo(kFilterMaterialViewHeight);
    }];
}

- (void)setupBeautifySwitch {
    self.beautifySwitch = [UISwitch new];
    self.beautifySwitch.onTintColor = ThemeColor;
    self.beautifySwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.beautifySwitch addTarget:self action:@selector(beautifySwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.beautifySwitch];
    [self.beautifySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self.filterMaterialView.mas_bottom).offset(8);
    }];
    
    UILabel *switchLab = [UILabel new];
    switchLab.textColor = [UIColor whiteColor];
    switchLab.font = [UIFont systemFontOfSize:12];
    switchLab.text = @"美颜";
    [self addSubview:switchLab];
    [switchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beautifySwitch.mas_right).offset(3);
        make.centerY.equalTo(self.beautifySwitch);
    }];
}


- (void)setupBeautiftySldier {
    self.beautyifySlider = [UISlider new];
    self.beautyifySlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.beautyifySlider.minimumTrackTintColor = [UIColor whiteColor];
    self.beautyifySlider.maximumTrackTintColor = RGBA(255, 255, 255, 0);
    self.beautyifySlider.value = 0.5;
    self.beautyifySlider.alpha = 0;
    [self.beautyifySlider addTarget:self action:@selector(beautyifySliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.beautyifySlider];
    [self.beautyifySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beautifySwitch.mas_right).offset(30);
        make.centerY.equalTo(self.beautifySwitch);
        make.right.equalTo(self).offset(-10);
    }];
}

//MARK: Public
- (NSInteger)currentCategoryIndex {
    return self.filterCategoryView.currentIndex;
}

//MARK: Action

- (void)beautifySwitchValueChanged:(id)sender {
    [self.beautyifySlider setHidden:!self.beautifySwitch.isOn animated:YES completion:NULL];
    if ([self.delegate respondsToSelector:@selector(filterBarView:beautifySwitchIsOn:)]) {
        [self.delegate filterBarView:self beautifySwitchIsOn:self.beautifySwitch.isOn];
    }
}

- (void)beautyifySliderValueChanged:(id)sender {
    if ([self.delegate respondsToSelector:@selector(filterBarView:beautifySliderChangeToValue:)]) {
        [self.delegate filterBarView:self beautifySliderChangeToValue:self.beautyifySlider.value];
    }
}

//MARK: Custom Accessor
- (void)setDefaultFilterMaterials:(NSArray<SCFilterMaterialModel *> *)defaultFilterMaterials {
    _defaultFilterMaterials = [defaultFilterMaterials copy];
    if (self.filterCategoryView.currentIndex ==  0) {
        self.filterMaterialView.itemList = defaultFilterMaterials;
    }
}

- (void)setTiktokFilterMaterials:(NSArray<SCFilterMaterialModel *> *)tiktokFilterMaterials {
    _tiktokFilterMaterials = [tiktokFilterMaterials copy];
    if (self.filterCategoryView.currentIndex == 1) {
        self.filterMaterialView.itemList = tiktokFilterMaterials;
    }
}

//MARK: SCFilterMaterialViewDelegate

- (void)filteMateralView:(SCFilterMaterialView *)filterMaterialView didScrollviewToIndex:(NSInteger)index;{
    if ([self.delegate respondsToSelector:@selector(filterBarView:materialDidScrollViewToIndex:)]) {
        [self.delegate filterBarView:self materialDidScrollViewToIndex:index];
    }
}

//MARK: SCFilterCategoryViewDelegate
- (void)filterCategoryView:(SCFilterCategoryView *)filterCategoryView didScrollToIndex:(NSUInteger)index {
    NSInteger currentIndex = filterCategoryView.currentIndex;
    if (currentIndex == 0) {
        self.filterMaterialView.itemList = self.defaultFilterMaterials;
    }else if (currentIndex == 1){
        self.filterMaterialView.itemList = self.tiktokFilterMaterials;
    }
    if ([self.delegate respondsToSelector:@selector(filterBarView:categoryDidScrollviewToIndex:)]) {
        [self.delegate filterBarView:self categoryDidScrollviewToIndex:index];
    }
}

@end
