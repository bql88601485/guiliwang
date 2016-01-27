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

#import "A0_SigninBoard_iPhone.h"
#import "A1_SignupBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "A1_SigupNewViewController.h"

#import "TencentLogin.h"
#import "QQApiInterface.h"
#import "WeiXinLogin.h"
#import "WXApi.h"
#import "AppBoard_iPhone.h"

#import "A2_ ForgetBoard_iPhone.h"

#pragma mark -

@interface A0_SigninBoard_iPhone()

@property (retain, nonatomic) IBOutlet UITextField *userTe;
@property (retain, nonatomic) IBOutlet UITextField *passW;

@property (retain, nonatomic) IBOutlet UIButton *showPass;
@property (retain, nonatomic) IBOutlet UIButton *weixinButton;

@end


@implementation A0_SigninBoard_iPhone

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.userModel );
}


- (IBAction)zhuceEvent:(id)sender {
    
    
    A1_SigupNewViewController *sigup = [[A1_SigupNewViewController alloc] initWithNibName:@"A1_SigupNewViewController" bundle:nil];
    
    sigup.goBack = ^(){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:sigup animated:YES completion:^{
        
    }];
}

- (IBAction)showPawwEvent:(id)sender {
    
    A2__ForgetBoard_iPhone *fogot = [[A2__ForgetBoard_iPhone alloc] initWithNibName:@"A2_ ForgetBoard_iPhone" bundle:nil];
    
    
    __block A0_SigninBoard_iPhone *blck = self;
    fogot.goBack = ^(){
        
        [blck dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:fogot animated:YES completion:^{
        
    }];
}
- (IBAction)sendLoagin:(id)sender {
    [self doLogin];
}
#pragma mark - KVO
- (void)textFieldDidChange
{
    
    
    
}

- (IBAction)goback:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)qqloge:(id)sender {
    
    TencentLogin *tenLogin = [TencentLogin sharedInstance];
    __block A0_SigninBoard_iPhone *blck = self;
    [tenLogin TencentLogin:^(TenCentLoginStatus status, NSDictionary *userInfo) {
        
        [blck presentLoadingTips:__TEXT(@"manage2_over")];
        
        if (status == TenCentLoginStatus_OK) {
            [blck.userModel OtherUpApp:@"qq" username:[userInfo objectForKey:@"nickname"] openid:[userInfo objectForKey:@"openId"]];
        }
        
    }];
}
- (IBAction)weixinLogin:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {
        
        [self presentLoadingTips:__TEXT(@"tips_loading")];
        __block A0_SigninBoard_iPhone *blck = self;
        WeiXinLogin *login = [WeiXinLogin sharedInstance];
        [login WeiXinLogin:^(WeiXinLoginStatus status, NSDictionary *userInfo) {
            
            [blck presentLoadingTips:__TEXT(@"manage2_over")];
            
            [blck.userModel OtherUpApp:@"wx" username:[userInfo objectForKey:@"nickname"] openid:[userInfo objectForKey:@"openid"]];
            
        }];
        
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([WXApi isWXAppInstalled]) {
        
        
        [_weixinButton setHidden:NO];
    }else{
        [_weixinButton setHidden:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.userTe addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.passW addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    
    [self.userTe setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passW setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:UserModel.KICKOUT];
    [self observeNotification:UserModel.UPDATED];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFileBegin) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFileEnd) name:UITextFieldTextDidEndEditingNotification object:nil];
}


#pragma mark -

- (void)doLogin
{
    NSString * userName = self.userTe.text;
    NSString * password = self.passW.text;
    
    if ( 0 == userName.length || NO == [userName isChineseUserName] )
    {
        [self presentMessageTips:__TEXT(@"wrong_username")];
        return;
    }
    
    if ( userName.length < 2 )
    {
        [self presentMessageTips:__TEXT(@"username_too_short")];
        return;
    }
    
    if ( userName.length > 20 )
    {
        [self presentMessageTips:__TEXT(@"username_too_long")];
        return;
    }
    
    if ( 0 == password.length || NO == [password isPassword] )
    {
        [self presentMessageTips:__TEXT(@"wrong_password")];
        return;
    }
    
    if ( password.length < 6 )
    {
        [self presentMessageTips:__TEXT(@"password_too_short")];
        return;
    }
    
    if ( password.length > 20 )
    {
        [self presentMessageTips:__TEXT(@"password_too_long")];
        return;
    }
    
    [self.userModel signinWithUser:userName password:password];
}

#pragma mark -

ON_MESSAGE3( API, user_signin, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"signing_in")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( msg.succeed )
    {
        if ( [UserModel sharedInstance].firstUse )
        {
            [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome")];
        }
        else
        {
            [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome_back")];
        }
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}
ON_MESSAGE3( API, existuser, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"signing_in")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( msg.succeed )
    {
        if ( [UserModel sharedInstance].firstUse )
        {
            [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome")];
        }
        else
        {
            [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome_back")];
        }
        
        self.userModel.user = msg.GET_OUTPUT (@"data_user");
        self.userModel.session = msg.GET_OUTPUT (@"data_session");
        
        
        [self.userModel setOnline:YES];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
      
        }];
        
    }
    else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}
- (void)dealloc {
    [_userTe release];
    [_passW release];
    [_showPass release];
    [_weixinButton release];
    [super dealloc];
}



- (void)TextFileBegin
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.frame = CGRectMake(0, -140, self.view.width, self.view.height);
        
    }];
}
- (void)TextFileEnd{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

@end
