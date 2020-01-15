//
//  SCFilterBarView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilterMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SCFilterBarView;
@protocol SCFilterBarViewDelegate <NSObject>

- (void)filterBarView:(SCFilterBarView *)filterBarView categoryDidScrollviewToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView materialDidScrollViewToIndex:(NSUInteger)index;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySwitchIsOn:(BOOL)isOn;
- (void)filterBarView:(SCFilterBarView *)filterBarView beautifySliderChangeToValue:(CGFloat)value;

@end

@interface SCFilterBarView : UIView

@property (nonatomic) BOOL showing;
@property (nonatomic, weak) id<SCFilterBarViewDelegate> delegate;

///内置滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *defaultFilterMaterials;

///抖音滤镜
@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *tiktokFilterMaterials;

- (NSInteger)currentCategoryIndex;

@end

NS_ASSUME_NONNULL_END
