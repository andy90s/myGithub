//
//  PayManager.m
//
//  Created by 虾丸 on 15/11/4.
//  Copyright © 2015年 TaiDu. All rights reserved.
//

#import "PayManager.h"

//支付宝支付相关
#import "AlipayOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

//微信支付相关
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"

#import "DataMD5.h"
#import "getIPhoneIP.h"

#import "XMLDictionary.h"
#import "AFNetworking.h"

//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>

@interface PayManager ()

@property (nonatomic, copy) PayResult payRes;

@end

@implementation PayManager


-(instancetype)initWithOrderID:(NSString *)orderID
                      OrderNum:(NSString *)orderNum
                   productName:(NSString *)productName
            productDescription:(NSString *)productDescription
                         price:(CGFloat)price{
    self = [super init];
    
    if (self) {
        self.orderID = orderID;
        self.orderNum = orderNum;
        self.productName = productName;
        self.productDescription = productDescription;
        self.price = price;
    }
    return self;
    
}

-(void)result:(PayResult)block{
    self.payRes = block;
}

#pragma AliPay

/**
 *  支付宝支付
 *
 *  @param orderID            订单ID
 *  @param productName        商品名
 *  @param productDescription 商品简介
 *  @param price              商品价格
 */
- (void)AliPay{
    
    if (!self.orderID ||
        !self.productName ||
        !self.productDescription ||
        self.price == 0 ||
        self.notifyURL == nil){
        NSLog(@"参数不足");
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = AliPay_partner;
    order.seller = Alipay_seller;
    order.tradeNO = self.orderID; //订单ID
    order.productName = self.productName; //商品标题
    order.productDescription = self.productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.price]; //商品价格
    order.notifyURL =  self.notifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    [self AliPayWithOrder:order];
}

- (void)AliPayWithOrder:(AlipayOrder *)alipayOrder{
    
    if (alipayOrder == nil) {
        NSLog(@"参数不足");
        return;
    }
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [alipayOrder description];
    
    [self AliPayWithOrderSpec:orderSpec];
    
}

- (void)AliPayWithOrderSpec:(NSString *)orderSpec{
    
    if (orderSpec == nil) {
        NSLog(@"参数不足");
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"HeiHang";
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(Alipay_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"reslut = %@",resultDic);
            NSString *resultStatus = resultDic[@"resultStatus"];
            BOOL result = [resultStatus isEqualToString:@"9000"]?YES:NO;
            if (self.payRes) {
                self.payRes(result);
            }
        }];
        
    }
}

#pragma WeChatPay

- (void)WeChatPayWithNonceStr:(NSString *)nonceStr{
    
    if (!self.orderID ||
        !self.productName ||
        nonceStr == nil ||
        self.price == 0 ||
        self.notifyURL == nil){
        NSLog(@"参数不足");
        return;
    }
    
    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
    //应用APPID
    appid = WeiChatAppID;
    //微信支付商户号
    mch_id = WeChatPay_MCHID;
    ///产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    nonce_str = nonceStr;
    
    body = self.productName;
    
    out_trade_no = self.orderID;
    //交易价格1表示0.01元，10表示0.1元
    total_fee = @(self.price*100).stringValue;
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    spbill_create_ip =[getIPhoneIP getIPAddress];
    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    notify_url = self.notifyURL;
    trade_type =@"APP";
    //商户密钥
    partner = WeChatPay_PARTNERID;
    //获取sign签名
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid
                                            mch_id:mch_id
                                         nonce_str:nonce_str
                                        partner_id:partner
                                              body:body
                                      out_trade_no:out_trade_no
                                         total_fee:total_fee
                                  spbill_create_ip:spbill_create_ip
                                        notify_url:notify_url
                                        trade_type:trade_type];
    sign = [data getSignForMD5];
    //设置参数并转化成xml格式
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"];//公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"];//商户号
    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:body forKey:@"body"];//商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:total_fee forKey:@"total_fee"];//金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:trade_type forKey:@"trade_type"];//交易类型
    
    NSString *string = [dic XMLString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return string;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:string success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            
            [self WeChatPayWithPrepayId:[dic objectForKey:@"prepay_id"] noncestr:[dic objectForKey:@"nonce_str"]];
            
            
        }else{
            NSLog(@"参数不正确，请检查参数");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)WeChatPayWithPrepayId:(NSString *)prepayId
                     noncestr:(NSString *)noncestr{
    
    if (prepayId == nil || noncestr == nil) {
        NSLog(@"参数不足");
    }
    
    PayReq* request = [[PayReq alloc] init];
    request.partnerId = WeChatPay_PARTNERID;
    request.prepayId = prepayId;
    request.package = @"Sign=WXPay";
    request.nonceStr= noncestr;
    //将当前事件转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    request.timeStamp= timeStamp;
    DataMD5 *md5 = [[DataMD5 alloc] init];
    request.sign=[md5 createMD5SingForPay:WeiChatAppID
                                partnerid:request.partnerId
                                 prepayid:request.prepayId
                                  package:request.package
                                 noncestr:request.nonceStr
                                timestamp:request.timeStamp];
    //            调用微信
    [WXApi sendReq:request];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Other

-(void)setOrderID:(NSString *)orderID{
    
    _orderID = orderID;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payFinish:)
                                                 name:NotificationName_PayResult
                                               object:nil];
}


- (void)payFinish:(NSNotification *)note {
    
    NSNumber *result = note.object[@"result"];
    
    if (self.payRes) {
        self.payRes(result.boolValue);
    }
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
}

#pragma 临时方法
///产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//将订单号使用md5加密
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//产生随机数
- (NSString *)getOrderNumber{
    int random = arc4random()%10000;
    return [self md5:[NSString stringWithFormat:@"%d",random]];
}




+ (void)payResult:(BOOL)result{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(result),@"result", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_PayResult object:dic];
}

@end
