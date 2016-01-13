//
//  TencentLogin.m
//  shop
//
//  Created by bai on 15/11/15.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "TencentLogin.h"
#import "TencentOAuth.h"

@interface TencentLogin()<TencentSessionDelegate>
{
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
}

@property (nonatomic, strong) BackTencentLoginStatus  kblock;

@property (nonatomic, assign) TenCentLoginStatus      kstatus;

@end

@implementation TencentLogin

DEF_SINGLETON(TencentLogin);


- (void)TencentLogin:(BackTencentLoginStatus)block
{
    if (nil == tencentOAuth) {
        
        tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1104138285"andDelegate:self];
        
        permissions= [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    }
    
    self.kblock = block;
    
    [tencentOAuth authorize:permissions];
}



#pragma mark -- TencentSessionDelegate
//TODO: 登陆完成调用
- (void)tencentDidLogin
{
    if (tencentOAuth.accessToken &&0 != [tencentOAuth.accessToken length])
    {
        //TODO:  记录登录用户的OpenID、Token以及过期时间
        self.kstatus = TenCentLoginStatus_OK;
    }
    else
    {
       //TODO:   登录不成功没有获取accesstoken
        self.kstatus = TenCentLoginStatus_error;
    }
    
    [tencentOAuth getUserInfo];
}

//TODO: 非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    self.kstatus = TenCentLoginStatus_error;
    if (cancelled)
    {
        //TODO: 用户取消登录
    }else{
       //TODO: 登录失败
    }
}

//TODO: 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
   //TODO: 无网络连接，请设置网络
    self.kstatus = TenCentLoginStatus_error;
}

//TODO: 用户信息
-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    
    if (self.kblock) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:response.jsonResponse];
        [dic setObject:tencentOAuth.openId forKey:@"openId"];
        
        self.kblock(self.kstatus,dic);
    }
    
}

@end
