//
//  WebViewController.m
//  shop
//
//  Created by baiqilong on 16/1/19.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "WebViewController.h"
#import "model.h"
#import "controller.h"
#import "AppBoard_iPhone.h"
@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHome = NO;
    // Do any additional setup after loading the view from its nib.
    self.title= @"物流说明";
    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];;
}
ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [bee.ui.appBoard hideTabbar];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
