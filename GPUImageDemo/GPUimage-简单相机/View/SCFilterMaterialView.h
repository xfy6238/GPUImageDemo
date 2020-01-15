//
//  SCFilterMaterialView.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilterMaterialModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SCFilterMaterialView;
@protocol SCFilterMaterialViewDelegate <NSObject>

- (void)filteMateralView:(SCFilterMaterialView *)filterMaterialView didScrollviewToIndex:(NSInteger)index;

@end

@interface SCFilterMaterialView : UIView

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *itemList;
@property (nonatomic, weak) id <SCFilterMaterialViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
