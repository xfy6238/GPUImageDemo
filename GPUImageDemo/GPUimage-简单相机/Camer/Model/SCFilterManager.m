//
//  SCFilterManager.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/8.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterManager.h"

static SCFilterManager *_filterManager;

@interface SCFilterManager ()

@property (nonatomic, strong) NSArray <SCFilterMaterialModel *> *defaultFilters;
@property (nonatomic, strong) NSArray <SCFilterMaterialModel *> *tiktokFilters;

@property (nonatomic, strong) NSDictionary *defaultFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *tikTokFilterMateriallsInfo;

@property (nonatomic, strong) NSMutableDictionary *filterClassInfo;

@end

@implementation SCFilterManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterManager = [[SCFilterManager alloc]init];
    });
    return _filterManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

//MARK: Public
- (GPUImageFilter *)filerWithFilterID:(NSString *)filterID {
    NSString *className = self.filterClassInfo[filterID];
    Class filterClass = NSClassFromString(className);
    return [[filterClass alloc]init];
}

//MARK: Private

- (void)commonInit {
    self.filterClassInfo = @{}.mutableCopy;
    [self setupDefaultFilterMaterialsInfo];
    [self setupTiktokFilterMaterialsInfo];
}

- (void)setupDefaultFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefaultFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    self.defaultFilterMaterialsInfo = [info copy];;
}

- (void)setupTiktokFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TikTokFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    self.tikTokFilterMateriallsInfo = [info copy];;
}

- (NSArray<SCFilterMaterialModel *> *)setupFiltersWithInfo:(NSDictionary *)info {
    NSMutableArray *mutaArray = @[].mutableCopy;
    
    NSArray *defaultArray = info[@"Default"];
    
    for (NSDictionary *dict in defaultArray) {
        SCFilterMaterialModel *model = [[SCFilterMaterialModel alloc]init];
        model.filterID = dict[@"filter_id"];
        model.filterName = dict[@"filter_name"];
        
        [mutaArray addObject:model];
        
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
    return [mutaArray copy];
}


//MARK: Custom Accessor
- (NSArray <SCFilterMaterialModel *> *)defaultFilters {
    if (!_defaultFilters) {
        _defaultFilters = [self setupFiltersWithInfo:self.defaultFilterMaterialsInfo];
    }
    return _defaultFilters;
}


- (NSArray<SCFilterMaterialModel *> *)tiktokFilters {
    if (!_tiktokFilters) {
        _tiktokFilters = [self setupFiltersWithInfo:self.tikTokFilterMateriallsInfo];
    }
    return _tiktokFilters;
}

@end
