//
//  SCFilterHandler.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/2.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "SCFilterHandler.h"
#import "SSGPUImageBaseFilter.h"
#import "LFGPUImageBeautyFilter.h"

@interface SCFilterHandler ()

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;

//当前剪裁滤镜
@property (nonatomic, strong) GPUImageCropFilter *currentCropFilter;

@property (nonatomic, weak) GPUImageFilter *currentBeautifyFilter;
@property (nonatomic, weak) GPUImageFilter *currentEffectFilter;

@property (nonatomic, strong) LFGPUImageBeautyFilter *defaultBeautifyFilter;

@property (nonatomic, strong)  CADisplayLink *displayLink; //用来刷新时间

@end

@implementation SCFilterHandler

- (void)dealloc {
    [self endDispayLink];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


//MARK: Public


- (GPUImageFilter *)firstFilter {
    return self.filters.firstObject;
}

- (GPUImageFilter *)lastFilter {
    return self.filters.lastObject;
}

- (void)setCropRect:(CGRect)rect {
    self.currentCropFilter.cropRegion = rect;
}

- (void)addFilter:(GPUImageFilter *)filter {
#pragma mark: 这里的操作没有看明白 不知道为什么取出最后一个filter的targets,然后再添加到新的filter中
    
    //1.找出原 最后 一个滤镜的所有targets
    NSArray *targets = self.filters.lastObject.targets;
    //2. 移除原filter的所有targets
    [self.filters.lastObject removeAllTargets];
    //原最有一个滤镜的target为现在新添的滤镜
    [self.filters.lastObject addTarget:filter];
    //将原filter的最后一个target对象一一添加为现在的filter的targets
    //一直很迷惑为什么是添加input 输入 到targets里,这里理解错了, 这个对象是id类型,实现了input协议; 实际还是一个output实现了input协议
    //知道input是个协议, 但是这里还是犯了蠢
    for (id <GPUImageInput> input in targets) {
        [filter addTarget:input];
    }
    [self.filters addObject:filter];
}

- (void)setEffectFilter:(GPUImageFilter *)filter {
    if (!filter) {
        filter = [[GPUImageFilter alloc]init];
    }
    //如果不存在currentEffectFilter,将这个滤镜添加到滤镜数组中
    if (!self.currentEffectFilter) { //currentEffectFilter 不存在,则将初始化的filter添加到数组中
        [self addFilter:filter];
    }else{ //已经存在currentEffectFilter,找到它在数组中的下标;
        //
        NSInteger index = [self.filters indexOfObject:self.currentEffectFilter];
        //找出这个滤镜  如果位置是0 表明这个数组当前就只有这一个filter
        //如果不是 找到它的前一个filter为source
        GPUImageOutput *source = index == 0? self.source : self.filters[index - 1];
        //找出currentEffectFilter 的所有targets,添加到现在要设置的filter上
        for (id <GPUImageInput> input in self.currentEffectFilter.targets) {
            [filter addTarget:input];
        }
        //source 这是的targets要变更,为新的设置的filter
        [source removeTarget:self.currentEffectFilter];
        //之前的currentEffectFilter 移除所有targets 因为,它的targets已经被添加到新的filter中了
        [self.currentEffectFilter removeAllTargets];
        [source addTarget:filter];
        //将数组中的currentEffectFilter 设置为新的filter
        self.filters[index] = filter;
    }
    //更新currentEffectFilter
    self.currentEffectFilter = filter;
    
    //记录应用时间
    if ([filter isKindOfClass:[SSGPUImageBaseFilter class]]) {
        ((SSGPUImageBaseFilter *)filter).beginTime   = self.displayLink.timestamp;
    }
}
//MARK: Custom Accessor

- (void)setBeautifyFilterEnable:(BOOL)beautifyFilterEnable {
    _beautifyFilterEnable = beautifyFilterEnable;
    [self setBeautifyFilter:beautifyFilterEnable ? (GPUImageFilter *)self.defaultBeautifyFilter : nil];
}

- (void)setBeautifyFilterDegree:(CGFloat)beautifyFilterDegree {
    if (!_beautifyFilterEnable) {
        return;
    }
    _beautifyFilterDegree = beautifyFilterDegree;
    self.defaultBeautifyFilter.beautyLevel = beautifyFilterDegree;
}

- (LFGPUImageBeautyFilter *)defaultBeautifyFilter {
    if (!_defaultBeautifyFilter) {
        _defaultBeautifyFilter = [LFGPUImageBeautyFilter new];
    }
    return _defaultBeautifyFilter;
}


//MARK: Private
- (void)commonInit {
    _beautifyFilterDegree = 0.5f;
    self.filters = @[].mutableCopy;
    [self addCropFilter];
    [self addBeautifyFilter];
    [self setupDisplayLink];
}

- (void)addCropFilter {
    self.currentCropFilter = [GPUImageCropFilter new];
    [self addFilter:self.currentCropFilter];
}

- (void)addBeautifyFilter {
    [self setBeautifyFilter:nil];
}

- (void)setBeautifyFilter:(GPUImageFilter *)filter {
    if (!filter) {
        filter = [GPUImageFilter new];
    }
    if (!self.currentBeautifyFilter) {
        [self addFilter:filter];
    } else {
        NSInteger index = [self.filters indexOfObject:self.currentBeautifyFilter];
        GPUImageOutput *source = index == 0? self.source : self.filters[index - 1];
        for (id <GPUImageInput> input in self.currentBeautifyFilter.targets) {
            [filter addTarget:input];
        }
        [source removeTarget:self.currentBeautifyFilter];
        [self.currentBeautifyFilter removeAllTargets];
        [source addTarget:filter];
        self.filters[index] = filter;
    }
    self.currentBeautifyFilter = filter;
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)endDispayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}


//MARK: Action
- (void)displayAction {
    if ([self.currentEffectFilter isKindOfClass:[SSGPUImageBaseFilter class]]) {
        SSGPUImageBaseFilter *filter = (SSGPUImageBaseFilter *)self.currentEffectFilter;
        filter.time = self.displayLink.timestamp - filter.beginTime;
    }
}

@end
