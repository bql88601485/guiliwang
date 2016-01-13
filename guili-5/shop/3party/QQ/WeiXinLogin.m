//
//  WeiXinLogin.m
//  shop
//
//  Created by bai on 15/11/15.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "WeiXinLogin.h"
#import "WXApi.h"
@interface WeiXinLogin()
{
    NSString *access_token;
    NSString *openid;
    
    
    NSString *wxCode;
}

@property (nonatomic, strong) BackWeiXinLoginStatus  kblock;

@property (nonatomic, assign) WeiXinLoginStatus      kstatus;

@end

@implementation WeiXinLogin

DEF_SINGLETON(WeiXinLogin);

- (void)WeiXinLogin:(BackWeiXinLoginStatus)block
{
    self.kblock = block;
    [self sendAuthRequest];
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"12345";
    [WXApi sendReq:req];
}

-(void)getAccess_token
{
    NSString *KWeiXinId = [[NSUserDefaults standardUserDefaults] objectForKey:@"K_WX_APPID"];
    NSString *KAppKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"K_PAY_SIGN_KEY"];
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KWeiXinId,KAppKey,wxCode];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                access_token = [dic objectForKey:@"access_token"];
                openid = [dic objectForKey:@"openid"];
                
                [self getUserInfo];
            }
        });
    });
}

-(void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    __weak NSString *weakS = openid;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (self.kblock) {
                    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithDictionary:dic];
                    [dic1 setObject:weakS forKey:@"openid"];
                    self.kblock(WeiXinLoginStatus_OK, dic1);
                }
            }
        });
        
    });
}

//TODO: 授权后回调 WXApiDelegate
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        wxCode = aresp.code;
        [self getAccess_token];
    }
}

@end
