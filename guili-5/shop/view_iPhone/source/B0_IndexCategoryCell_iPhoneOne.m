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
//	Powered by BeeFramework
//

#import "B0_IndexCategoryCell_iPhoneOne.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_IndexCategoryCell_iPhoneOne

DEF_SIGNAL( CATEGORY_TOUCHED )
DEF_SIGNAL( GOODS1_TOUCHED )
DEF_SIGNAL( GOODS2_TOUCHED )
DEF_SIGNAL( GOODS3_TOUCHED )
DEF_SIGNAL( GOODS4_TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

- (void)load
{
    //	self.layoutOnce = YES;
}

- (void)unload
{
}

- (void)dataDidChanged
{
    CATEGORY * category = self.data;
    if ( category )
    {
        $(@"#cate_name").TEXT( category.name );
        
        SIMPLE_GOODS * goods = [category.goods objectAtIndex:0];
        
        $(@"#goods-title1").SHOW();
        $(@"#goods-title1").TEXT( goods.name );
        
        $(@"#goods-price1").SHOW();
        $(@"#goods-price1").TEXT( goods.shop_price );
        
        $(@"#goods-image1").SHOW();
        $(@"#goods-image1").IMAGE( goods.img.thumbURL );
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, goods3, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS3_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, goods4, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS4_TOUCHED];
    }
}

@end