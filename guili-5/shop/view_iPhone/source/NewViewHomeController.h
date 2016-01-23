//
//  NewViewHomeController.h
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "BaseBoard_iPhone.h"

#import "model.h"
#import "controller.h"

#import "UIViewController+ErrorTips.h"
#import "ZBarSDK.h"


@interface NewViewHomeController : BaseBoard_iPhone<UITextFieldDelegate,ZBarReaderDelegate>

AS_INT( ACTION_ADD )
AS_INT( ACTION_BUY )
AS_INT( ACTION_SPEC )

AS_MODEL( BannerModel,		bannerModel );
AS_MODEL( CategoryModel,	categoryModel );


@end
