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

#import "B0_IndexCategoryCell_iPhoneOne_1.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_IndexCategoryCell_iPhoneOne_1

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
        
        if (category.change > 0) {
            $(@"#cate_image").HIDE();
            $(@"#cate_name").HIDE();
        }else{
            $(@"#cate_image").SHOW();
            $(@"#cate_name").SHOW();
        }
        
        SIMPLE_GOODS * goods = [category.goods objectAtIndex:0];
        
        $(@"#goods-title1").SHOW();
        $(@"#goods-title1").TEXT( goods.name );
        
        $(@"#goods-price1").SHOW();
        $(@"#goods-price1").TEXT( goods.shop_price );
        
        if (NO){
            $(@"#goods-old1").SHOW();
            $(@"#goods-old1").TEXT( goods.market_price );
            $(@"#goods-subprice-line").SHOW();
        }else{
            $(@"#goods-old1").HIDE();
            $(@"#goods-subprice-line").HIDE();
        }
        
        $(@"#goods-image1").SHOW();
        $(@"#goods-image1").IMAGE( goods.img.url );
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne_1, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne_1, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne_1, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne_1, goods3, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS3_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne_1, goods4, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS4_TOUCHED];
    }
}

@end
