//
//  G0_CommentVController.m
//  shop
//
//  Created by baiqilong on 16/1/21.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "G0_CommentVController.h"
#import "Comment.h"
#import "Bee_Model.h"
#import "UIViewController+ErrorTips.h"
@interface G0_CommentVController ()

@property (retain, nonatomic) IBOutlet BeeUIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *kTitle;
@property (retain, nonatomic) IBOutlet UILabel *pricelable;

@property (retain, nonatomic) IBOutlet UITextView *textView;

@property (retain, nonatomic) IBOutlet UIButton *sendBUtton;

@end

@implementation G0_CommentVController


DEF_MODEL( Comment, commet )

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commet = [Comment modelWithObserver:self];
    
    self.navigationBarTitle = __TEXT(@"order_comment");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    self.sendBUtton.enabled = NO;
    [self showData];
}

- (void)showData{
    
    [self.iconImage GET:self.Kgoods.img.url useCache:YES];
    [self.kTitle setText:self.Kgoods.name];
    self.pricelable.text = [NSString stringWithFormat:@"%@",self.Kgoods.formated_shop_price];
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendComment:(id)sender {
    
    if (self.textView.text.length > 0) {
        [self.commet sendComment:[self.Kgoods.goods_id stringValue] comment:self.textView.text];
    }
}

- (void)dealloc {
    [_iconImage release];
    [_kTitle release];
    [_pricelable release];
    [_textView release];
    [_sendBUtton release];
    [super dealloc];
}

#pragma mark - textde
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.view.top = -50;
        
    }];
    
    if ([textView.text isEqualToString:@"写下购买体会或使用过程中带来的帮助，可以为其他小伙伴提供参考~"]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.view.top = 64;
        
    }];
    
    if (textView.text.length == 0) {
        textView.text = @"写下购买体会或使用过程中带来的帮助，可以为其他小伙伴提供参考~";
        self.sendBUtton.enabled = NO;
    }else{
        self.sendBUtton.enabled = YES;
    }
}
//
ON_MESSAGE3( API, SENDCOMMENT, msg )
{
    if ( msg.sending )
    {
        [self presentLoadingTips:@"发送"];
    }
    else if ( msg.succeed )
    {
        
        STATUS * status = msg.GET_OUTPUT(@"status");
        
        if ([status.succeed intValue] == 1) {
            [self presentSuccessTips:__TEXT(@"success_share")];
            __block G0_CommentVController *weakI = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakI.stack popBoardAnimated:YES];
            });
        }
    }
    else if ( msg.failed )
    {
        [self dismissTips];
        [self showErrorTips:msg];
    }
    else
    {
        [self dismissTips];
    }
    
    
}

@end
