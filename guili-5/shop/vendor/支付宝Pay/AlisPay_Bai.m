//
//  AlisPay_Bai.m
//  BQLPayLib
//
//  Created by bai on 16/1/27.
//  Copyright © 2016年 baiqilong. All rights reserved.
//

#import "AlisPay_Bai.h"
#import "DataSigner.h"



static AlisPay_Bai *staticSelf = nil;

@interface AlisPay_Bai()

@property (nonatomic, strong) CompletionBlock completionBlock;

@end

@implementation AlisPay_Bai

+ (instancetype)initAlisPay{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticSelf = [[AlisPay_Bai alloc] init];
    });
    
    return staticSelf;
}
//TODO: 下单
- (void)PayOrder:(Order *)order callback:(CompletionBlock)completionBlock{
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    // 配置支付宝
    order.partner		= [userDefaults objectForKey:@"K_ALIPAY_PARTNER"];
    order.seller		= [userDefaults objectForKey:@"K_ALIPAY_SELLER"];
//    alipay.config.privateKey	= [userDefaults objectForKey:@"K_ALIPAY_PRIVATE"];
    order.notifyURL		= [userDefaults objectForKey:@"K_ALIPAY_CALLBACK"];
    order.appID = @"2016092401965170";
    
    //partner和seller获取失败,提示
    if ([KEY_partner length] == 0 ||
        [KEY_privateKey length] == 0)
    {
        if (completionBlock) {
            completionBlock(@{@"error":@"缺少partner或者seller或者私钥"});
        }
        
        return;
    }
    
    
    order.partner = KEY_partner;
    order.seller = KEY_seller;
    order.notifyURL =  @"http://www.guiliwang.cn/"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme =@"guiliwang";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(KEY_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:completionBlock];
        self.completionBlock = completionBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoPay:) name:@"GOTO_PAY_ZFB" object:nil];
        
    }
    
    
}

- (void)gotoPay:(NSNotification *)NOT{

    if (self.completionBlock) {
        self.completionBlock(NOT.object);
        self.completionBlock = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GOTO_PAY_ZFB" object:nil];
    }
}

@end
