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

#import "controller.h"
#import "model.h"

#import "UIViewController+ErrorTips.h"

/**
 * 收货地址管理-添加地址board
 */
@interface F1_NewAddressBoard_iPhone : BaseBoard_iPhone

AS_OUTLET( BeeUIScrollView, list )

AS_SIGNAL(DELETE_CONFIRM);

AS_MODEL( AddressListModel,	addressListModel )
AS_MODEL( RegionModel,		regionModel )

@property (nonatomic, assign) BOOL shouldShowMessage;
@property (nonatomic, assign) BOOL isShopingCartBord;
@property (nonatomic, retain) ADDRESS * address;
@property (nonatomic, retain) BaseBoard_iPhone * shopingCartBod;

@property (nonatomic, retain) UIView *footView;


@property (nonatomic, assign) BOOL isChange;
@end