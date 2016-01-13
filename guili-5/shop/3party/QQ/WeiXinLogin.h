//
//  WeiXinLogin.h
//  shop
//
//  Created by bai on 15/11/15.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

typedef NS_ENUM(NSUInteger, WeiXinLoginStatus) {
    WeiXinLoginStatus_OK = 100,
    WeiXinLoginStatus_error,
};

typedef void(^BackWeiXinLoginStatus)(WeiXinLoginStatus status, NSDictionary *userInfo);


@interface WeiXinLogin : NSObject<WXApiDelegate>

AS_SINGLETON(WeiXinLogin);

- (void)WeiXinLogin:(BackWeiXinLoginStatus )block;

@end
