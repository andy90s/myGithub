//
//  TouchViewController.m
//  3DTouchDemo
//
//  Created by xhliang on 16/1/20.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "TouchViewController.h"

@interface TouchViewController ()<UIPreviewActionItem>

@end

@implementation TouchViewController

-(instancetype)init
{
    if (self = [super init]) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [story instantiateViewControllerWithIdentifier:@"touch"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/**
 *  Quick Actions菜单需要在这里设置 更多需求请参看苹果文档
 *
 *  @return
 */
-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action0 = [UIPreviewAction actionWithTitle:@"标题0" style:0 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点击了这个标题0");
    }];
    return @[action0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
