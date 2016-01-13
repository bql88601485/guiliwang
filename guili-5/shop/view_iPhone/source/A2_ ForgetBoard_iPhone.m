//
//  A2_ ForgetBoard_iPhone.m
//  shop
//
//  Created by bai on 15/12/1.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "A2_ ForgetBoard_iPhone.h"

#import "A1_SigupNewViewController.h"
#import "TencentLogin.h"
#import "QQApiInterface.h"
#import "WeiXinLogin.h"
#import "WXApi.h"
#import "AppBoard_iPhone.h"

@interface A2__ForgetBoard_iPhone ()
{
    NSTimer *codeTime;
    
    NSInteger timeLong;
}
@property (nonatomic, strong) PhoneCode *code;

@property (retain, nonatomic) IBOutlet UITextField *phoneNume;
@property (retain, nonatomic) IBOutlet UITextField *CodeNumber;
@property (retain, nonatomic) IBOutlet UITextField *PassWNum;
@property (retain, nonatomic) IBOutlet UIButton *sendCodeButton;

@property (retain, nonatomic) IBOutlet UIButton *senRig;


@property (retain, nonatomic) IBOutlet UIButton *showPaww;
@end

@implementation A2__ForgetBoard_iPhone

DEF_MODEL(UserModel, userModel)


- (void)load
{
    timeLong = 60;
    self.userModel = [UserModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.userModel );
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.senRig.enabled = NO;
    
    [self.phoneNume addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.CodeNumber addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.PassWNum addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    
    [self.phoneNume setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.CodeNumber setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.PassWNum setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:UserModel.KICKOUT];
    [self observeNotification:UserModel.UPDATED];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFileBegin) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFileEnd) name:UITextFieldTextDidEndEditingNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - KVO
- (void)textFieldDidChange
{
    
    if (( 0 != _phoneNume.text.length && YES == [_phoneNume.text  isTelephone] ) && (nil != _CodeNumber.text) && (0 != _PassWNum.text.length && YES == [_PassWNum.text isPassword])) {
        self.senRig.enabled = YES;
    }else
    {
        self.senRig.enabled = NO;
    }
    
}

#pragma mark - action
- (IBAction)showPawwAtion:(id)sender {
    
    
    [_showPaww setSelected:!_showPaww.isSelected];
    
    [_PassWNum setSecureTextEntry:self.showPaww.isSelected];
    
}

- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)sendRegisterMy{
    NSString * phone = _phoneNume.text;
    NSString * password = _PassWNum.text;
    NSString * password2 = _PassWNum.text;
    
    if ( 0 == phone.length || NO == [phone isTelephone] )
    {
        [self presentMessageTips:__TEXT(@"PhoneError")];
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
    
    if ( NO == [password isEqualToString:password2] )
    {
        [self presentMessageTips:__TEXT(@"wrong_password")];
        return;
    }
    
    [self.userModel FogetWithUser:phone password:password];
    
}
- (IBAction)registerAction:(id)sender {
    [self.userModel user_sendcode:_phoneNume.text codeNum:_CodeNumber.text];
}

- (IBAction)getPhoneCode:(id)sender {
    
    if (0 == _phoneNume.text.length || NO == [_phoneNume.text isTelephone]) {
        
        [self presentMessageTips:__TEXT(@"PhoneError")];
        
        return;
    }
    
    [self.userModel getCodeNum:_phoneNume.text];
    
    _sendCodeButton.enabled = NO;
}

- (void)Update:(id )userInfo
{
    if (timeLong == -1) {
        [codeTime invalidate];
        codeTime = nil;
        _sendCodeButton.enabled = YES;
        [_sendCodeButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        
        return;
    }
    _sendCodeButton.enabled = NO;
    NSString *title = [NSString stringWithFormat:@"重新刷新%zd秒",timeLong];
    
    [_sendCodeButton setTitle:title forState:UIControlStateNormal];
    
    timeLong--;
}
- (void)dealloc {
    [_phoneNume release];
    [_CodeNumber release];
    [_PassWNum release];
    [_sendCodeButton release];
    [_senRig release];
    [_showPaww release];
    [super dealloc];
}

#pragma mark - mag

ON_MESSAGE3(API, getCode, msg){
    
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"GetCode")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( msg.succeed )
    {
        self.code = msg.GET_OUTPUT (@"data_phoneCode");
        
        if (self.code.code.length > 0) {
            
            codeTime = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(Update:)userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:codeTime forMode:NSDefaultRunLoopMode];
            [codeTime fire];
            
        }else{
            _sendCodeButton.enabled = YES;
        }
        
    }
    else if ( msg.failed )
    {
        _sendCodeButton.enabled = YES;
        [self showErrorTips:msg];
    }
    
}
ON_MESSAGE3(API, sendCode, msg)
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"CheckCode")];
    }
    else
    {
        [self dismissTips];
    }
    
    if ( msg.succeed )
    {
        NSDictionary *dic = msg.GET_OUTPUT (@"data");
        
        if ([[dic objectForKey:@"datastatus"] intValue] == 1 ) {
            
            [self sendRegisterMy];
            
        }
        
    }
    else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}
ON_MESSAGE3( API, user_updatepwd, msg )
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
        STATUS * status = msg.GET_OUTPUT(@"data_status");
        
        if ( status && status.succeed.boolValue )
        {
            if ( self.userModel.firstUse )
            {
                [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome")];
            }
            else
            {
                [bee.ui.appBoard presentSuccessTips:__TEXT(@"welcome_back")];
            }
            
            self.userModel.session = msg.GET_OUTPUT( @"data_session" );
            self.userModel.user = msg.GET_OUTPUT( @"data_user" );
            self.userModel.loaded = YES;
            
            [self.userModel setOnline:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.goBack) {
                    self.goBack();
                }
            }];
        }
        else
        {
            [self showErrorTips:msg];
        }
    }
    else if ( msg.failed )
    {
        [self showErrorTips:msg];
    }
}
#pragma mark -

ON_NOTIFICATION3( UserModel, KICKOUT, n )
{
    
}

ON_NOTIFICATION3( UserModel, LOGOUT, n )
{
}

ON_NOTIFICATION3( UserModel, LOGIN, n )
{
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
