//
//  G0_CommentVController.m
//  shop
//
//  Created by baiqilong on 16/1/21.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "G0_CommentVController.h"

@interface G0_CommentVController ()

@property (retain, nonatomic) IBOutlet BeeUIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *kTitle;
@property (retain, nonatomic) IBOutlet UILabel *pricelable;

@property (retain, nonatomic) IBOutlet UITextView *textView;


@end

@implementation G0_CommentVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = __TEXT(@"order_comment");
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    
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
    
}

- (void)dealloc {
    [_iconImage release];
    [_kTitle release];
    [_pricelable release];
    [_textView release];
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
    }
}

@end
