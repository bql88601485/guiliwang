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

#import "model.h"
#import "controller.h"

#import "UIViewController+ErrorTips.h"
#import "ZBarSDK.h"
#pragma mark -

@interface B0_IndexBoard_iPhone : BaseBoard_iPhone<UITextFieldDelegate,ZBarReaderDelegate>
{
    UITextField * searchField;
}

AS_INT( ACTION_ADD )
AS_INT( ACTION_BUY )
AS_INT( ACTION_SPEC )

AS_MODEL( BannerModel,		bannerModel );
AS_MODEL( CategoryModel,	categoryModel );

AS_OUTLET( BeeUIScrollView, list )

AS_OUTLET( BeeUITextField, search_input);

@end
