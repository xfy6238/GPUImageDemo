//
//  VaguePictureController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/12.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "VaguePictureController.h"
#import <GPUImageView.h>
#import <GPUImagePicture.h>
#import <GPUImageSepiaFilter.h>
#import <GPUImageTiltShiftFilter.h>


@interface VaguePictureController ()

@property (nonatomic,strong) GPUImagePicture *sourcePic;
@property (nonatomic,strong) GPUImageTiltShiftFilter *sepiaFilter;

@end

@implementation VaguePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    GPUImageView *primaryView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    self.view = primaryView;
    
    
    UIImage *inputImage = [UIImage imageNamed:@"face.png"];
    _sourcePic = [[GPUImagePicture alloc]initWithImage:inputImage];
    _sepiaFilter = [[GPUImageTiltShiftFilter alloc]init];
    //设置 模糊像素
    _sepiaFilter.blurRadiusInPixels = 100.0;
    //方法作用:根据输入真的大小来设置处理方式
    [_sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels];
    
    [_sourcePic addTarget:_sepiaFilter];
    [_sepiaFilter addTarget:primaryView];
    [_sourcePic processImage];

    
    
    //GPUImageContext的 相关的数据显示
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    GLint unit = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"%d %d %d", size, unit, vector);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    float rate = point.y / self.view.frame.size.height;
    NSLog(@"Processing");
    [_sepiaFilter setTopFocusLevel:rate - 0.1];
    [_sepiaFilter setBottomFocusLevel:rate + 0.1];
    [_sourcePic processImage];
}


@end
