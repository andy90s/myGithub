### 前言
---
最近在做微信支付以及支付宝支付两项功能.

发现支付宝支付提供的接口对开发者十分的友好, 而微信支付的Demo难道是实习生做的?

在参考了cocoaChina中`狂龙天使`的[微信支付demo](http://www.cocoachina.com/bbs/read.php?tid-309177-keyword-%CE%A2%D0%C5%D6%A7%B8%B6.html)之后,还是很艰难地将微信支付的大坑解决掉了.

为了能够使遇到相同问题的同学不再纠结, 所以将最后的整合版本放出. 希望能给大家提供到帮助

### Reorganize_AliPay_WeChatPay
---

* 支持微信 1.6.1 版本
* 支持支付宝 3.0.1 版本


#### 依赖说明
---
1. 添加微信SDK, AlipaySDK.
2. 添加微信依赖文件: `getIPhoneIP` , `DataMD5` , `openssl` , `XMLDictionary`.
3. 按照官方文档添加 `APP UrlScheme`.
4. 按照官方文档添加 `Frameworks`依赖库.


#### 注意事项
---
1. 是否使用了友盟SDK, 如果有使用, 请参考一下文章调整调用顺序. [链接](http://www.cocoachina.com/bbs/read.php?tid-321546.html)
2. 如果使用了ShareSDK, 微信SDK不需要初始化.
3. openSSL如果产生报错问题, 请参考以下文章. [链接](http://blog.csdn.net/l648320605/article/details/38919861)


#### 使用说明
---
###### 导入依赖文件及PayManager类.

###### AppDelegate中方法添加

1. 导入PayManager文件

		#import "PayManager.h"
2. 初始化微信SDK

		[WXApi registerApp:WeiChatAppID];	
3. 添加支付回调数据处理方法

	方法1:

		-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
		
	方法2:

		-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
		
	方法3:

		- (BOOL)application:(UIApplication *)application
              		open(NSURL *)urlURL:
  		sourceApplication:(NSString *)sourceApplication
         		annotation:(id)annotation ;

4. 添加微信处理方法

		-(void)onReq:(BaseReq *)req{
    
		}

		-(void)onResp:(BaseResp *)resp{	
    	NSString *strTitle;
    	if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    	}
    	if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        BOOL isSuccess  = NO;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付成功!");
                isSuccess = YES;
            }
                break;
            case WXErrCodeCommon:
            case WXErrCodeUserCancel:
            case WXErrCodeSentFail:
            case WXErrCodeUnsupport:
            case WXErrCodeAuthDeny:
            default:
            {
                NSLog(@"支付失败!");
                isSuccess = NO;
                
            }
                break;
        }
        
        [self payResult:isSuccess];
    	}
		}


5. 添加PayManager处理方法

		- (void)payResult:(BOOL)isSuccess{
    	[PayManager payResult:isSuccess];
		}
		

###### 初始化 PayManager
方法1: 保守方法, 添加依赖参数, 保证其他方法调用无误 

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
                   		productName:(NSString *)productName
            	productDescription:(NSString *)productDescription
                         		price:(CGFloat)price;


方法2:默认方法

	-(instancetype)init; //绝对不要调用!!
	
###### 方法调用

	
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
	



###### 结果回调处理

通过以下方法对支付结果进行回调

	
	- (void)result:(PayResult)block;

#### DEMO
---

	/*
	*	init
	*/
    self.payManager = [[PayManager alloc]initWithOrderID:self.order.OrderId
                                             productName:self.order.Title
                                      productDescription:self.order.description
                                                   price:self.order.Price.floatValue];
    [self.payManager result:^(BOOL isSuccess) {
        if (isSuccess) {
            //支付成功;
        }else{
            //支付失败;
        }
    }];
    
    ---
    /*
    *	微信支付
    */
    
    //检测是否安装了微信
    if (![WXApi isWXAppInstalled]){
	//未安装微信的提示  
    }else{
		[self.payManager WeChatPayWithAppid:appid
									Noncestr:Noncestr
									Packagename:Packagename
 									Partnerid:Partnerid
         							Prepayid:Prepayid];
    }
    
    ---
    /*
    *	支付宝支付
    */
	[self.payManager AliPayWithOrderSpec:OrderSpec];
	
#### 期待
---
* 我相信这个DEMO还是有很多问题, 但是对于初步使用应该有很好的帮助. 

* 如果你觉得有什么问题, 请issues我. 

* 如果想pull, 那就尽情的来吧!
