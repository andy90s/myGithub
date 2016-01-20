//
//  XHTouch.m
//  3DTouchDemo
//
//  Created by xhliang on 16/1/20.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "XHTouch.h"

@implementation XHTouch


+(void)createTouchItems:(UIApplication *)application
{
    /**
     *  图标，尺寸大小为35X35 需要2X 3X图 具体根据自己需要来
     */
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ryzen"];
    /** type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"代码设置" localizedTitle:@"代码设置" localizedSubtitle:@"副标题" icon:icon1 userInfo:nil];
    /** 将items 添加到app图标 */
    application.shortcutItems = @[item1];
}

@end
