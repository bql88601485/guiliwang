//
//  AlisPay_Bai.h
//  BQLPayLib
//
//  Created by bai on 16/1/27.
//  Copyright © 2016年 baiqilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
#define KEY_partner     @"2088611315193750"
#define KEY_seller      @"2088611315193750"
#define KEY_privateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANLu/PdltLTXLSKaMkh4ZqttHUUNXj1g1HaOAY2OWM35OOz4nndMsJy65zWd86b21ng+Dsgz57fiR46w5UwX6+anVhUUAM+7WrlNXpQlleYkrdvJPi1MpnjltCFU1hyAo22eJFq/ZAxXCZ/l2sL9XSpjk2a3VDjKWrOOq7E8cpTLAgMBAAECgYEAgaVklEbN5+ztj/wIdeSS7kCVofCSgNU4IVos+C2Kxaat53D0LU1UrDBwldLshC3pKmSyPzkv7iTFaJ2vgbKeSbsi46VNZ1x9EYhZsKqHw6Z3XPyIwlpk1+g/ZCvuFwDo2C/yXBUOlc5sMONaTnbfgSXawFq7O5xTtuTqLqbvPpECQQD5nxkzKIlGwaP/nB/ZKDw+nRiAYAl8d474uH/M5swQj8itlUTs2MqfreHL9vyTSG+2ps20JQiSxx8AKGohBGjzAkEA2FLP7GendTl0PmQTwmMp2Xz3WS1cLymrL2G7weteMngKCR5vuP2/0BFojFrTH7raBi+QD5/XVxwURRbDSj6ayQJBAJjWmDhhpoPjRoXYUwvEfface4cGxmgmUCzr0pxj6Chv0SCvV69pIc9ZSPp4tLd9T6FXSnX1guVT9CBFno2uxI8CQFfWUG0qrZlwyd2nn0pYH58bGgiQ3ZSc89Cae7XDD42oplKLlEvmZSNkXjJXktCYe3z1hSaC/dp2IVjoZEXaY9kCQE1HRwZdgDJa9W8JFCze/vWpkdiE+THssvtp61jqMJw9ocfRnQG3Fz6ViT9fHL+U1xjATHP3E/34hruzwwoLr40="
/*============================================================================*/
/*============================================================================*/
/*============================================================================*/

@interface AlisPay_Bai : NSObject
/**
 *  @author bai, 16-01-27 16:01:44
 *
 *  @brief 必转，否则无法回调成功
 */
@property (nonatomic , strong) NSString *appScheme;//应用注册scheme,在AlixPayDemo-Info.plist定义URL types

/**
 *  @author bai, 16-01-27 16:01:50
 *
 *  @brief 注册对象
 *
 *  @return 返回支付宝支付对象
 */
+ (instancetype)initAlisPay;

/**
 *  @author bai, 16-01-27 16:01:31
 *
 *  @brief 去支付
 *
 *  @param order           订单信息
 *  @param completionBlock 支付回调
 */
- (void)PayOrder:(Order *)order callback:(CompletionBlock)completionBlock;

@end
