//
//  XHTouch.h
//  3DTouchDemo
//
//  Created by xhliang on 16/1/20.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XHTouch : NSObject

/**
 *  注意:
 *  3DTouch桌面快捷启动设置 有两种方式 代码设置(动态)
 *                        也可以去plist里面设置(静态)
 *  两者都可以 也可以共存
 *
 *  问题1:代码设置的如果注释有时候需要删除应用重新运行
 *  问题2:plist里面设置没有提示功能 至少我的是这样(具体去看本Demo中Plist UIApplicationShortcutItems参数)
 */

+(void)createTouchItems:(UIApplication *)application;


@end
