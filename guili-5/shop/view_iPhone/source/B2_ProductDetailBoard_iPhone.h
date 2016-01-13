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
//  Powered by BeeFramework
//
	
#import "Bee.h"
#import "BaseBoard_iPhone.h"
#import "B2_ProductDetailTabCell_iPhone.h"

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

#import "ZBarSDK.h"

#pragma mark -

@interface B2_ProductDetailBoard_iPhone : BaseBoard_iPhone<ZBarReaderDelegate>
{
    NSTimer *	_timer;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * _line;
    UIButton * searchBtn;
    UITextField * searchField;
}
AS_INT( ACTION_ADD )
AS_INT( ACTION_BUY )
AS_INT( ACTION_SPEC )

AS_INT( ITERM1 )
AS_INT( ITERM2 )
AS_INT( ITERM3 )
AS_INT( ITERM4 )

AS_OUTLET( BeeUIScrollView, list )
AS_OUTLET( B2_ProductDetailTabCell_iPhone, tabbar )

/**
 * 商品详情-分享-新浪微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_SINA )

/**
 * 商品详情-分享-腾讯微博，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_TENCENT )

/**
 * 商品详情-分享-微信朋友圈，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_FRIEND )

/**
 * 商品详情-分享-微信，点击时触发该事件
 */
AS_SIGNAL( SHARE_TO_WEIXIN_TIMELINE )

AS_MODEL( CartModel,		cartModel )
AS_MODEL( GoodsInfoModel,	goodsModel )
AS_MODEL( CollectionModel,	collectionModel )
AS_MODEL( GoodsPageModel, goodsPageModel )
AS_MODEL( CommentModel, commentModel )

@property (nonatomic, copy) NSString *          htmlString;

@property (nonatomic, assign) NSUInteger		action; // called path for showing specView
@property (nonatomic, retain) NSMutableArray *  specs;
@property (nonatomic, assign) NSNumber *        count;
@property (nonatomic, assign) NSNumber *        specfied;
@property(nonatomic,assign ) NSUInteger  menu_action;
@property(nonatomic,assign ) NSUInteger  loginType;
@property(nonatomic,assign ) BOOL  isOpt;
@end
