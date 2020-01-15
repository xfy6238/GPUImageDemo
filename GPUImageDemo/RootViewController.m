//
//  RootViewController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/11.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "RootViewController.h"

#import "AVVideoController.h"

#import "GPUImageListController.h"
#import "SCCamerController.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    _datasource = [NSMutableArray array];
    NSString *str1 = @"GPUImageDemo";
    NSString *str2 = @"AVFoundation";
    NSString *str3 = @"GPUimage实现简单相机";


    [_datasource addObject:str1];
    [_datasource addObject:str2];
    [_datasource addObject:str3];

    NSArray *tmpArray = @[@1,@3,@4];
    NSInteger index = [tmpArray indexOfObject:@(1)];
    NSLog(@"%ld",index);
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

    if ([currentStr isEqualToString:@"GPUImageDemo"]) {
        con = [[GPUImageListController alloc]init];
    }
    if ([currentStr isEqualToString:@"AVFoundation"]) {
        con = [[AVVideoController alloc]init];
    }
    if ([currentStr isEqualToString:@"GPUimage实现简单相机"]) {
        con = [[SCCamerController alloc]init];
    }
    
    [self.navigationController pushViewController:con animated:YES];
}


@end
