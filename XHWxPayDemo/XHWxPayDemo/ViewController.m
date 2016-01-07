//
//  ViewController.m
//  XHWxPayDemo
//
//  Created by xhliang on 16/1/6.
//  Copyright © 2016年 xhliang. All rights reserved.
//

#import "ViewController.h"

#import "WXApi.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableDictionary *parameters;

//仅仅是标记第一个按钮是否点击(是否获取了preid)
@property (nonatomic,assign) BOOL isClick;

- (IBAction)preClick:(id)sender;

- (IBAction)wxPayClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isClick = NO;
    // Do any additional setup after loading the view, typically from a nib.
    
}
//获取预支付ID
-(void)GetPrePayId
{
    WXHelper *help = [[WXHelper alloc]initWithAppID:WXAPI_KEY mchID:WXAPI_PARTNERID spKey:WXPARTNER_SCRET];
    //价格是分为单位
    _parameters = [help getPrepayWithOrderName:@"测试" price:@"1" device:@"013467007045764"];
    _isClick = YES;
}

//跳转微信
-(void)gotoWxPayFroApp
{
    if (_isClick) {
       [WXHelper jumpToWXAppWithParams:_parameters];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)preClick:(id)sender {
    [self GetPrePayId];
}

- (IBAction)wxPayClick:(id)sender {
    [self gotoWxPayFroApp];
}
@end
