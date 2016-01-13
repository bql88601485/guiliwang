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

#import "Bee.h"

#pragma mark -

/**
 * 首页中分类型展示商品的cell
 */

@interface B0_IndexCategoryCell_iPhoneTwo : BeeUICell

/**
 * 首页-分类商品-分类，点击时触发该事件
 */
AS_SIGNAL( CATEGORY_TOUCHED )

/**
 * 首页-分类商品-商品1，点击时触发该事件
 */
AS_SIGNAL( GOODS1_TOUCHED )

/**
 * 首页-分类商品-商品2，点击时触发该事件
 */
AS_SIGNAL( GOODS2_TOUCHED )
@end
