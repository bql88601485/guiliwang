//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "Bee.h"
typedef void (^onPaymentSucceed)(ORDER_INFO *order);
typedef void (^onPaymentFailed)(ORDER_INFO *order);

@interface WXPayClient : NSObject<WXApiDelegate>
@property(nonatomic, strong) ORDER_INFO *order;
@property(nonatomic, copy) onPaymentSucceed succeed;
@property(nonatomic, copy) onPaymentSucceed failed;
@property(nonatomic,retain) NSString *accessToken;
@property int      token_time;
@property BOOL paied;
+ (instancetype)shareInstance;
- (void)payProduct;

@end
