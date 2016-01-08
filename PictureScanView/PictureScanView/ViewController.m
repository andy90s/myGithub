//
//  ViewController.m
//  PictureScanView
//
//  Created by xhliang on 15/12/30.
//  Copyright © 2015年 xhliang. All rights reserved.
//

#import "ViewController.h"

#import "XHPicView.h"

@interface ViewController ()

- (IBAction)picOneClick:(id)sender;

- (IBAction)picTwoClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)picOneClick:(id)sender {
    
    UIImage *image0 = [UIImage imageNamed:@"test0.jpg"];
    UIImage *image1 = [UIImage imageNamed:@"test1.jpg"];
    NSArray *imageArr = @[image0,image1];
    XHPicView *picView = [[XHPicView alloc]initWithFrame:self.view.frame withImgs:imageArr withImgUrl:nil];
    picView.eventBlock = ^(NSString *event){
        NSLog(@"触发事件%@",event);
    };
    [self.view addSubview:picView];
}

- (IBAction)picTwoClick:(id)sender {
    NSArray *imgUrls = @[@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg",@"http://imgk.zol.com.cn/dcbbs/2342/a2341460.jpg"];
    XHPicView *picView = [[XHPicView alloc]initWithFrame:self.view.frame withImgs:nil withImgUrl:imgUrls];
    picView.eventBlock = ^(NSString *event){
        NSLog(@"触发事件%@",event);
    };
    [self.view addSubview:picView];
}
@end
