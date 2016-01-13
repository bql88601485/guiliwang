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

#import "B0_IndexCategoryCell_iPhone.h"
#import "PHOTO+AutoSelection.h"

#pragma mark -

@implementation B0_IndexCategoryCell_iPhone

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
		
		if ( category.goods.count > 0 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:0];
			
			$(@"#category-image").SHOW();
            $(@"#category-title").TEXT(goods.name);;
			$(@"#category-image").IMAGE( goods.img.thumbURL );
		}
		else
		{
            $(@"#category-image").HIDE();
		}
		
		if ( category.goods.count > 1 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:1];
			
			$(@"#goods-title1").SHOW();
			$(@"#goods-title1").TEXT( goods.name );
            
			$(@"#goods-price1").SHOW();
			$(@"#goods-price1").TEXT( goods.shop_price );
			
			$(@"#goods-image1").SHOW();
			$(@"#goods-image1").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title1").HIDE();
			$(@"#goods-price1").HIDE();
            $(@"#goods-image1").HIDE();
		}
        
		if ( category.goods.count > 2 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:2];
            
			$(@"#goods-title2").SHOW();
			$(@"#goods-title2").TEXT( goods.name );
			
			$(@"#goods-price2").SHOW();
			$(@"#goods-price2").TEXT( goods.shop_price );
			
			$(@"#goods-image2").SHOW();
			$(@"#goods-image2").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title2").HIDE();
			$(@"#goods-price2").HIDE();
            $(@"#goods-image2").HIDE();
		}
        if ( category.goods.count > 3 )
        {
            SIMPLE_GOODS * goods = [category.goods objectAtIndex:3];
            
            $(@"#goods-title3").SHOW();
            $(@"#goods-title3").TEXT( goods.name );
            
            $(@"#goods-price3").SHOW();
            $(@"#goods-price3").TEXT( goods.shop_price );
            
            $(@"#goods-image3").SHOW();
            $(@"#goods-image3").IMAGE( goods.img.thumbURL );
        }
        else
        {
            $(@"#goods-title3").HIDE();
            $(@"#goods-price3").HIDE();
            $(@"#goods-image3").HIDE();
        }
        if ( category.goods.count > 4 )
        {
            SIMPLE_GOODS * goods = [category.goods objectAtIndex:4];
            
            $(@"#goods-title4").SHOW();
            $(@"#goods-title4").TEXT( goods.name );
            
            $(@"#goods-price4").SHOW();
            $(@"#goods-price4").TEXT( goods.shop_price );
            
            $(@"#goods-image4").SHOW();
            $(@"#goods-image4").IMAGE( goods.img.thumbURL );
        }
        else
        {
            $(@"#goods-title4").HIDE();
            $(@"#goods-price4").HIDE();
            $(@"#goods-image4").HIDE();
        }
	}
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhone, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhone, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( B0_IndexCategoryCell_iPhone, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, goods3, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS3_TOUCHED];
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, goods4, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS4_TOUCHED];
    }
}

@end
