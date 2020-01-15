//
//  VideoTableController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/13.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "VideoTableController.h"
#import "VideoWaterController.h"

@interface VideoTableController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;

@end

@implementation VideoTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    _datasource = [NSMutableArray array];
    NSString *str1 = @"水印是视频";
    [_datasource addObject:str1];
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
    if ([currentStr containsString:@"视频"]) {
        con = [[VideoWaterController alloc]init];
    }
    
    [self.navigationController pushViewController:con animated:YES];
}


@end
