//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by xhliang on 16/1/20.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "AppDelegate.h"
#import "XHTouch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  创建3DTouch快捷图标
 *
 *  @param application
 *  @param launchOptions
 *
 *  @return
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /**
     *  这里是代码和plist共存介绍3Dtouch, plist设置查看plist文件
     */
    [XHTouch createTouchItems:application];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  新提供的方法用来对3DTouch操作
 *
 *  @param application       <#application description#>
 *  @param shortcutItem      <#shortcutItem description#>
 *  @param completionHandler <#completionHandler description#>
 */
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    /**
     *  判断方式可根据自己需要变更
     */
    if ([shortcutItem.localizedTitle isEqualToString:@"Plist设置"]) {
        NSLog(@"Plist设置");
    }
    if ([shortcutItem.localizedTitle isEqualToString:@"代码设置"]) {
        NSLog(@"代码设置");
    }
}

@end
