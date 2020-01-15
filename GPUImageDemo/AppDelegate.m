//
//  AppDelegate.m
//  GPUImageDemo
//
//  Created by 胥福阳 on 2019/11/9.
//  Copyright © 2019 xufuyang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    RootViewController *con = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:con];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [self commnontSet];
    
    return YES;
}

- (void)commnontSet {

    
}





@end
