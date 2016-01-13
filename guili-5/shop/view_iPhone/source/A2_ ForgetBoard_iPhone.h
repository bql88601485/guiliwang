//
//  A2_ ForgetBoard_iPhone.h
//  shop
//
//  Created by bai on 15/12/1.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "BaseBoard_iPhone.h"
#import "UserModel.h"
#import "UIViewController+ErrorTips.h"

#import "BaseBoard_iPhone.h"

#import "controller.h"
#import "model.h"
typedef void(^BackGO)();
@interface A2__ForgetBoard_iPhone : BaseBoard_iPhone

AS_MODEL(UserModel, userModel);

@property (nonatomic, strong) BackGO goBack;

@end
