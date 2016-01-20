//
//  ViewController.m
//  3DTouchDemo
//
//  Created by xhliang on 16/1/20.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "ViewController.h"
#import "TouchViewController.h"

@interface ViewController ()<UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UIView *touchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //这里是设置那里可以触发3DTouch
    [self registerForPreviewingWithDelegate:self sourceView:self.touchView];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma Touch delegate

/**
 *  peek手势
 *
 *  @param previewingContext
 *  @param location
 *
 *  @return
 */
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    TouchViewController *touch = [[TouchViewController alloc]init];
    touch.preferredContentSize = CGSizeMake(0.0f, [[UIScreen mainScreen] bounds].size.height - 100);
    touch.viewController = self;
    //轻按 高亮范围 可以没有
    CGRect rect = CGRectMake(10, location.y - 10, self.view.frame.size.width - 20, 50);//这个50的高度是点击触发3D Touch的高度，如果像短信之类的是表格，一般就是表格的高度
    previewingContext.sourceRect = rect;
    
    
    return touch;
}
/**
 *  pop手势
 *
 *  @param previewingContext
 *  @param viewControllerToCommit
 */
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
