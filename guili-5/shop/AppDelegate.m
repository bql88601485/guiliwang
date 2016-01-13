//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "AppDelegate.h"
#import "AppBoard_iPad.h"
#import "AppBoard_iPhone.h"

#import "controller.h"
#import "model.h"
#import "ecmobile.h"
#import "MobClick.h"

#import "bee.services.alipay.h"
#import "bee.services.location.h"
#import "bee.services.share.weixin.h"
#import "bee.services.share.sinaweibo.h"
#import "bee.services.share.tencentweibo.h"
#import "bee.services.wizard.h"
#import "bee.services.siri.h"
#import "bee.services.push.h"

#import "TencentOAuth.h"
#import "WeiXinLogin.h"
@implementation AppDelegate

#pragma mark -
- (void)load
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    bee.ui.config.ASR = YES;		// Signal自动路由
    bee.ui.config.iOS6Mode = YES;	// iOS6.0界面布局
    
    //[[BeeUITemplateManager sharedInstance] preloadResources];
    //[[BeeUITemplateManager sharedInstance] preloadPackages];
    
    
    [UserModel			sharedInstance];
    
    
    // 配置ECSHOP
    //[ServerConfig sharedInstance].url = @"http://shop.ecmobile.me/ecmobile/?url=";
    //    [ServerConfig sharedInstance].url = @"http://www.guiliwang.cn/ecmobile/?url=";
    [ServerConfig sharedInstance].url = @"http://114.215.93.127/ecmobile/?url=";
    [ServerConfig sharedInstance].app_root_url= @"http://www.guiliwang.cn/ecmobile";
    [ServerConfig sharedInstance].root_url= @"http://www.guiliwang.cn";
    
    //	// 配置自动刷新
    //	[bee.services.liveload.class setDefaultStyleFile:LIVE_UI_ABSOLUTE_PATH(@"view_iPhone/resource/css/default.css")];
    
    // 配置闪屏
    //bee.services.wizard.config.showBackground = YES;
    //bee.services.wizard.config.showPageControl = YES;
    //bee.services.wizard.config.backgroundImage = [UIImage imageNamed:@"tuitional_bg.jpg"];
    //bee.services.wizard.config.pageDotSize = CGSizeMake( 11.0f, 11.0f );
    //bee.services.wizard.config.pageDotNormal = [UIImage imageNamed:@"tuitional-carousel-active-btn.png"];
    //bee.services.wizard.config.pageDotHighlighted = [UIImage imageNamed:@"tuitional-carousel-btn.png"];
    //bee.services.wizard.config.pageDotLast = [UIImage imageNamed:@"tuitional-carousel-btn-last.png"];
    
    //bee.services.wizard.config.splashes[0] = @"wizard_1.xml";
    //bee.services.wizard.config.splashes[1] = @"wizard_2.xml";
    //bee.services.wizard.config.splashes[2] = @"wizard_3.xml";
    //bee.services.wizard.config.splashes[3] = @"wizard_4.xml";
    //bee.services.wizard.config.splashes[4] = @"wizard_5.xml";
    
    // 配置提示框
    {
        [BeeUITipsCenter setDefaultContainerView:self.window];
        [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
        [BeeUITipsCenter setDefaultMessageIcon:[UIImage imageNamed:@"icon.png"]];
        [BeeUITipsCenter setDefaultSuccessIcon:[UIImage imageNamed:@"icon.png"]];
        [BeeUITipsCenter setDefaultFailureIcon:[UIImage imageNamed:@"icon.png"]];
    }
    
    // 配置导航条
    {
        [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
        [BeeUINavigationBar setBackgroundColor:[UIColor blackColor]];
        
        if ( IOS7_OR_LATER )
        {
            [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_iphone5.png"]];
        }
        else
        {
            [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]];
        }
    }
    
    [self updateConfig];
    
    self.window.rootViewController = [AppBoard_iPhone sharedInstance];
    
    [MobClick appLaunched];
    
}

- (void)unload
{
    [self unobserveAllNotifications];
    
    [MobClick appTerminated];
    
}

#pragma mark -

- (void)updateConfig
{
    //	ALIAS( bee.services.share.weixin,		weixin );
    //	ALIAS( bee.services.share.tencentweibo,	tweibo );
    //	ALIAS( bee.services.share.sinaweibo,	sweibo );
    ALIAS( bee.services.alipay,				alipay );
    ALIAS( bee.services.siri,				siri );
    ALIAS( bee.services.location,			lbs );
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"wxceee178a9a48a66a" forKey:@"K_WX_APPID"];
    [userDefaults setObject:@"d4624c36b6795d1d99dcf0547af5443d" forKey:@"K_PAY_SIGN_KEY"];
    [WXApi registerApp:[userDefaults objectForKey:@"K_WX_APPID"] withDescription:@"d4624c36b6795d1d99dcf0547af5443d"];
    
    
    // 配置支付宝
    alipay.config.parnter		= [userDefaults objectForKey:@"K_ALIPAY_PARTNER"];
    alipay.config.seller		= [userDefaults objectForKey:@"K_ALIPAY_SELLER"];
    alipay.config.privateKey	= [userDefaults objectForKey:@"K_ALIPAY_PRIVATE"];
    alipay.config.publicKey		= [userDefaults objectForKey:@"K_ALIPAY_PUBLIC"];
    alipay.config.notifyURL		= [userDefaults objectForKey:@"K_ALIPAY_CALLBACK"];
    
    // 配置语音识别
    siri.config.showUI			= YES;
    siri.config.appID			= @"539980a8";
    
    // 配置友盟
    //[self openUM];
    
    [MobClick setAppVersion:[BeeSystemInfo appShortVersion]];
    [MobClick setCrashReportEnabled:YES];
    [MobClick setLatitude:lbs.location.coordinate.latitude longitude:lbs.location.coordinate.longitude];
    [MobClick setLocation:lbs.location];
    [MobClick startWithAppkey:[userDefaults objectForKey:@""]
                 reportPolicy:BATCH
                    channelId:[BeeSystemInfo appIdentifier]];
}


#pragma mark - login
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:[WeiXinLogin sharedInstance]];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:[WeiXinLogin sharedInstance]];
}

@end
