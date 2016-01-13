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

#import "B0_IndexCategoryCell_iPhoneTwo.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_IndexCategoryCell_iPhoneTwo

DEF_SIGNAL( CATEGORY_TOUCHED )
DEF_SIGNAL( GOODS1_TOUCHED )
DEF_SIGNAL( GOODS2_TOUCHED )

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
        
        
        goods = [category.goods objectAtIndex:1];
        
        $(@"#goods-title2").SHOW();
        $(@"#goods-title2").TEXT( goods.name );
        
        $(@"#goods-price2").SHOW();
        $(@"#goods-price2").TEXT( goods.shop_price );
        
        $(@"#goods-image2").SHOW();
        $(@"#goods-image2").IMAGE( goods.img.thumbURL );
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneTwo, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneTwo, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhoneTwo, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}

@end
