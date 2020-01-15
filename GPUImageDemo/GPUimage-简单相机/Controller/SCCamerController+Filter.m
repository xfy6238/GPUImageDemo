//
//  SCCamerController+Filter.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2020/1/9.
//  Copyright © 2020 xufuyang. All rights reserved.
//

#import "SCCamerController+Filter.h"
#import "SCCamerController+Private.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation SCCamerController (Filter)

- (void)addBeautifyFilter {
    [SCCamerManager shareManager].currentFilterHadle.beautifyFilterEnable = YES;
}

- (void)removeBeautifyFiter {
    [SCCamerManager shareManager].currentFilterHadle.beautifyFilterEnable = NO;
}

- (NSArray<SCFilterMaterialModel *> *)filterWithCategoryIndex:(NSInteger)index {
    if (index == 0) {
        return self.defaultFilterMaterias;
    } else if (index == 1) {
        return self.tiktokFilterMaterias;
    }
    return nil;
    
}

#pragma clang diagnostic pop

@end
