//
//  SCFilterMaterialViewCell.h
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilterMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCFilterMaterialViewCell : UICollectionViewCell

@property (nonatomic, strong) SCFilterMaterialModel *filterMaterialModel;
@property (nonatomic) BOOL  isSelect;


@end

NS_ASSUME_NONNULL_END
