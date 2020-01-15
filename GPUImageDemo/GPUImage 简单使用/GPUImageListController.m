//
//  GPUImageListController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/12/4.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "GPUImageListController.h"
#import "SimpleController.h"
#import "CamerVideoController.h"
#import "VaguePictureController.h"
#import "VideoFilterController.h"
#import "VideoTableController.h"
#import "QuartzController.h"
#import "GPUimageGroupController.h"


@interface GPUImageListController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;


@end

@implementation GPUImageListController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    _datasource = [NSMutableArray array];
    NSString *str1 = @"简单滤镜";
    NSString *str2 = @"简单cameraVideo";
    NSString *str3 = @"图片模糊";
    NSString *str4 = @"视频滤镜";
    NSString *str5 = @"视频水印";
    NSString *str6 = @"Quartz2D";
    NSString *str7 = @"组合滤镜";


    [_datasource addObject:str1];
    [_datasource addObject:str2];
    [_datasource addObject:str3];
    [_datasource addObject:str4];
    [_datasource addObject:str5];
    [_datasource addObject:str6];
    [_datasource addObject:str7];
}

//MARK: 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text  = _datasource[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentStr = _datasource[indexPath.row];
    
    UIViewController *con;
    if ([currentStr isEqualToString:@"简单滤镜"]) {
        con = [[SimpleController alloc]init];
    }
    if ([currentStr isEqualToString:@"简单cameraVideo"]) {
        con = [[CamerVideoController alloc]init];
   
    }
    if ([currentStr isEqualToString:@"图片模糊"]) {
        con = [[VaguePictureController alloc]init];
    }
    
    if ([currentStr isEqualToString:@"视频滤镜"]) {
        con = [[VideoFilterController alloc]init];
    }
    if ([currentStr isEqualToString:@"视频水印"]) {
           con = [[VideoTableController alloc]init];
       }
    if ([currentStr isEqualToString:@"Quartz2D"]) {
           con = [[QuartzController alloc]init];
       }
    if ([currentStr isEqualToString:@"组合滤镜"]) {
        con = [[GPUimageGroupController alloc]init];
    }

    [self.navigationController pushViewController:con animated:YES];
}
@end
