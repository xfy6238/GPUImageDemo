//
//  SCFilterCategoryView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SCFilterCategoryView;

@protocol SCFilterCategoryViewDelegate <NSObject>

- (void)filterCategoryView:(SCFilterCategoryView *)filterCategoryView didScrollToIndex:(NSUInteger)index;

@end
    
@interface SCFilterCategoryView : UIView

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic) CGFloat bottomLineWidth;
@property (nonatomic) CGFloat bottomLineHeight;

@property (nonatomic,readonly) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <NSString *> *itemList;

@property (nonatomic, weak) id <SCFilterCategoryViewDelegate> delegate;

- (void)scorllToIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
