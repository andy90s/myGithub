//
//  PayManager.h
//
//  Created by 虾丸 on 15/11/4.
//  Copyright © 2015年 TaiDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlipayOrder.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#define NotificationName_PayResult  @"NotificationName_PayResult"   //支付结果回调

//微信支付
#define WeiChatAppID @""    //微信APPID
#define WeChatPay_MCHID          @""   //商户号，填写商户对应参数
#define WeChatPay_PARTNERID      @""   //商户API密钥，填写相应参数
#define WeChatPay_SPURL          @""  //获取服务器端支付数据地址（商户自定义）

//支付宝支付
#define AliPay_partner  @""
#define Alipay_seller   @""
#define Alipay_privateKey   @""


typedef NS_ENUM(NSInteger, NHPayType) {
    NHPayTypeAlipay = 0, //支付宝支付
    NHPayTypeWeChatPay = 1,//微信支付
};

typedef void(^PayResult) (BOOL isSuccess);

@interface PayManager : NSObject

@property (nonatomic, strong) NSString *orderID;//订单ID
@property (nonatomic, strong) NSString *orderNum;//订单号
@property (nonatomic, strong) NSString *productName;//商品名称
@property (nonatomic, strong) NSString *productDescription;//商品简介
@property (nonatomic, assign) CGFloat price;//价格
@property (nonatomic, strong) NSString *notifyURL;//支付结果回调地址

@property (nonatomic, assign) NHPayType payType;//支付方式

/**
 *  初始化
 *
 *  @param orderID            订单(必填)
 *  @param orderNum           物品数量(选填)
 *  @param productName        商品名称(选填)
 *  @param productDescription 商品简介(选填)
 *  @param price              商品价格(选填)
 *
 *  @return self
 */
-(instancetype)initWithOrderID:(NSString *)orderID
                      OrderNum:(NSString *)orderNum
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                         price:(CGFloat)price;


#pragma mark - Ali pay

/**
 *  支付宝支付
 */
- (void)AliPay;

/**
 *  支付宝支付
 *
 *  @param alipayOrder alipayOrder
 */
- (void)AliPayWithOrder:(AlipayOrder *)alipayOrder;

/**
 *  支付宝支付
 *
 *  @param orderSpec order.description
 */
- (void)AliPayWithOrderSpec:(NSString *)orderSpec;


#pragma mark - WeiChat Pay

/**
 *  微信支付
 *
 *  @param nonceStr 防止产生重复订单的唯一的随机字符串
 */
- (void)WeChatPayWithNonceStr:(NSString *)nonceStr;

/**
 *  微信支付
 *
 *  @param prepayId 通过腾讯服务器与订单信息产生的订单ID
 *  @param noncestr 防止产生重复订单的唯一的随机字符串
 */
- (void)WeChatPayWithPrepayId:(NSString *)prepayId
                     noncestr:(NSString *)noncestr;

#pragma mark - Result
- (void)result:(PayResult)block;


#pragma mark - Other 请勿主动调用

+ (void)payResult:(BOOL)result;


@end
