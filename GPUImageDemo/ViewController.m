//
//  ViewController.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "ViewController.h"

#import "SimpleController.h"
#import "CamerVideoController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
    
    _datasource = [NSMutableArray array];
    NSString *str1 = @"简单滤镜1111";
    NSString *str2 = @"简单cameraVideo";

    [_datasource addObject:str1];
    [_datasource addObject:str2];

}





//MARK: 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text  = _datasource[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentStr = _datasource[indexPath.row];
    
    if ([currentStr isEqualToString:@"简单滤镜"]) {
        SimpleController *con = [[SimpleController alloc]init];
        [self.navigationController pushViewController:con animated:YES];
        return;
    }
    if ([currentStr isEqualToString:@"简单cameraVideo"]) {
        CamerVideoController *con = [[CamerVideoController alloc]init];
        [self.navigationController pushViewController:con animated:YES];
        return;
    }
}



@end
