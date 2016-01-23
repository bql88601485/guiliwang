//
//  A1_SigupNewViewController.h
//  shop
//
//  Created by bai on 15/11/15.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "BaseBoard_iPhone.h"
#import "UserModel.h"
#import "UIViewController+ErrorTips.h"

#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"
typedef void(^BackGO)();
@interface A1_SigupNewViewController : BeeUIBoard

AS_MODEL(UserModel, userModel);

@property (nonatomic, strong) BackGO goBack;

@end
