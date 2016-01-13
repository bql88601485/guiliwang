//
//  TencentLogin.h
//  shop
//
//  Created by bai on 15/11/15.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//
#import "Bee.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TenCentLoginStatus) {
    TenCentLoginStatus_OK = 100,
    TenCentLoginStatus_error,
};

typedef void(^BackTencentLoginStatus)(TenCentLoginStatus status, NSDictionary *userInfo);

@interface TencentLogin : NSObject

AS_SINGLETON(TencentLogin);


- (void)TencentLogin:(BackTencentLoginStatus )block;

@end
