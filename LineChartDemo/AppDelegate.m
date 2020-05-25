//
//  AppDelegate.m
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import "AppDelegate.h"
#import "XJCarmViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    
    NSMutableArray *arrShortcutItem = [NSMutableArray new];
        
    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"co.erplus.search" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [arrShortcutItem addObject:shoreItem1];
        
    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"co.erplus.newTask" localizedTitle:@"拍照" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCaptureVideo] userInfo:nil];
    [arrShortcutItem addObject:shoreItem2];
    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
    
    return YES;
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
    if ([shortcutItem.type isEqualToString:@"co.erplus.newTask"]) {//拍照
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"carm" object:nil];
        XJCarmViewController *vc = [XJCarmViewController new];
        UINavigationController *nv = (UINavigationController *) self.window.rootViewController;
        [nv pushViewController:vc animated:YES];
    }
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
