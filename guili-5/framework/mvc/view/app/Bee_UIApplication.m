//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "Bee_UIApplication.h"
#import "Bee_UIRouter.h"
#import "WXApi.h"
#import "WXPayClient.h"
#import "APService.h"
#pragma mark -

DEF_PACKAGE( BeePackage_UI, BeeUIApplication, application );

#pragma mark -

@interface BeeUIApplication()
{
    BOOL		_ready;
    NSUInteger	_device;
    UIWindow *	_window;
}

- (void)initWindow;

@end

#pragma mark -

@implementation BeeUIApplication

DEF_NOTIFICATION( LAUNCHED )		// did launched
DEF_NOTIFICATION( TERMINATED )		// will terminate

DEF_NOTIFICATION( STATE_CHANGED )	// state changed
DEF_NOTIFICATION( MEMORY_WARNING )	// memory warning

DEF_NOTIFICATION( LOCAL_NOTIFICATION )
DEF_NOTIFICATION( REMOTE_NOTIFICATION )

DEF_NOTIFICATION( APS_REGISTERED )
DEF_NOTIFICATION( APS_ERROR )

DEF_INT( DEVICE_CURRENT,		0 )
DEF_INT( DEVICE_PHONE_3_INCH,	1 )
DEF_INT( DEVICE_PHONE_4_INCH,	2 )

@synthesize ready = _ready;
@synthesize window = _window;
@dynamic device;
@dynamic inForeground;
@dynamic inBackground;

static BeeUIApplication * __sharedApp = nil;

+ (BeeUIApplication *)sharedInstance
{
    return __sharedApp;
}

- (void)load
{
    
}

- (void)unload
{
    [self JpushLoad];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        //		[self load];
        //[self performLoad];
    }
    return self;
}

- (void)dealloc
{
    //	[self unload];
    [self performUnload];
    
    [_window release];
    _window = nil;
    
    [super dealloc];
}

#pragma mark -

- (BOOL)inForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if ( UIApplicationStateActive == state )
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)inBackground
{
    return [self inForeground] ? NO : YES;
}

#pragma mark -

- (void)initWindow
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.alpha = 1.0f;
    //	self.window.layer.masksToBounds = YES;
    //	self.window.layer.opaque = YES;
    self.window.backgroundColor = [UIColor clearColor];
}

- (void)applySimulation
{
    CGRect phoneFrame = [[UIScreen mainScreen] bounds];
    
    if ([BeeSystemInfo isPadRetina] || [BeeSystemInfo isPad] )
    {
        if ( self.DEVICE_PHONE_3_INCH == _device )
        {
            phoneFrame.size.width = 640.0f;
            phoneFrame.size.height = 960.0f;
        }
        else if ( self.DEVICE_PHONE_4_INCH == _device )
        {
            phoneFrame.size.width = 640.0f;
            phoneFrame.size.height = 1136.0f;
        }
        
        if ( [BeeSystemInfo isPad] )
        {
            phoneFrame.size.width /= 2.0f;
            phoneFrame.size.height /= 2.0f;
        }
    }
    
    phoneFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - phoneFrame.size.width) / 2.0f;
    phoneFrame.origin.y = ([UIScreen mainScreen].bounds.size.height - phoneFrame.size.height) / 2.0f;
    
    self.window.frame = phoneFrame;
}

- (NSUInteger)device
{
    return _device;
}

- (void)setDevice:(NSUInteger)d
{
    if ( d != _device )
    {
        _device = d;
        
        if ( _ready )
        {
            [self applySimulation];
        }
    }
}

#pragma mark -
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
    [self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    __sharedApp = self;
    
    NSLog(@"位置1");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    NSLog(@"位置2");
    
    NSLog(@"位置20");
    [self initWindow];
    NSLog(@"位置21");
    //	[self load];
    [self performLoad];
    NSLog(@"位置3");
    
    if ( nil == self.window.rootViewController )
    {
        self.window.rootViewController = [BeeUIRouter sharedInstance];
    }
    
    if ( self.window.rootViewController )
    {
        UNUSED( self.window.rootViewController.view );
    }
    
    [self.window makeKeyAndVisible];
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    [APService setDebugMode];
    [self JpushLoad];
    //	[self applySimulation];
    
    /*if ( nil != launchOptions ) // 从通知启动
     {
     NSLog(@"位置4");
     NSURL *		url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
     NSString *	bundleID = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
     
     if ( url || bundleID )
     {
     NSMutableDictionary * params = [NSMutableDictionary dictionary];
     params.APPEND( @"url", url );
     params.APPEND( @"source", bundleID );
     
     [self postNotification:BeeUIApplication.LAUNCHED withObject:params];
     }
     else
     {
     [self postNotification:BeeUIApplication.LAUNCHED];
     }
     
     NSLog(@"位置5");
     UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
     if ( localNotification )
     {
     NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:localNotification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
     [self postNotification:BeeUIApplication.LOCAL_NOTIFICATION withObject:dict];
     }
     
     NSLog(@"位置6");
     NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     if ( remoteNotification )
     {
     NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:remoteNotification, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
     [self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
     }
     }
     else
     {
     [self postNotification:BeeUIApplication.LAUNCHED];
     }*/
    [self postNotification:BeeUIApplication.LAUNCHED];
    [self.window.rootViewController viewWillAppear:NO];
    [self.window.rootViewController viewDidAppear:NO];
    _ready = YES;
    //[self checkVersion];
    return YES;
}

// Will be deprecated at some point, please replace with application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self application:application openURL:url sourceApplication:nil annotation:nil];
}

// no equiv. notification. return NO if the application can't open for some reason
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ( [sourceApplication rangeOfString:@"tencent.x"].location != NSNotFound )
    {
        return [WXApi handleOpenURL:url delegate:[WXPayClient shareInstance]];
    }
    else if ( url || sourceApplication )
    {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params.APPEND( @"url", url );
        params.APPEND( @"source", sourceApplication );
        
        [self postNotification:BeeUIApplication.LAUNCHED withObject:params];
    }
    else
    {
        [self postNotification:BeeUIApplication.LAUNCHED];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.window.rootViewController viewWillAppear:NO];
    [self.window.rootViewController viewDidAppear:NO];
    
    [self postNotification:BeeUIApplication.STATE_CHANGED];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.window.rootViewController viewWillDisappear:NO];
    [self.window.rootViewController viewDidDisappear:NO];
    
    [self postNotification:BeeUIApplication.STATE_CHANGED];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [self postNotification:BeeUIApplication.MEMORY_WARNING];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self postNotification:BeeUIApplication.TERMINATED];
}

#pragma mark -

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    
}

#pragma mark -
// one of these will be called after calling -registerForRemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}
//新添加
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    completionHandler(UIBackgroundFetchResultNewData);
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
        [self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
    }
    else
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
        [self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
    }
    
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif
//新添加
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     if (launchOptions) {
     ///获取到推送相关的信息
     NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     }
     
     如果不处于后台收到远程推送时，可能要用到的方法
     */
    // Required
    
    
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
        [self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
    }
    else
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
        [self postNotification:BeeUIApplication.REMOTE_NOTIFICATION withObject:dict];
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if ( UIApplicationStateInactive == state || UIApplicationStateBackground == state )
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:NO], @"inApp", nil];
        [self postNotification:BeeUIApplication.LOCAL_NOTIFICATION withObject:dict];
    }
    else
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:notification.userInfo, @"userInfo", [NSNumber numberWithBool:YES], @"inApp", nil];
        [self postNotification:BeeUIApplication.LOCAL_NOTIFICATION withObject:dict];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self postNotification:BeeUIApplication.STATE_CHANGED];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [self postNotification:BeeUIApplication.STATE_CHANGED];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
}

/*  check app version. open in app store if diffrence version.
 NOTE: need to replace 'www.baidu.com' when submit.
 */


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"K_APPSTORE_URL"];
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:url]];
    }
}

-(void)JpushLoad{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}
-(void)JpushUnload{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}
- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"已连接");
    
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
