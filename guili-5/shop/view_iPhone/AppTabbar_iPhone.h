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

AS_UI( AppTabbar_iPhone, tabbar )

#pragma mark -

@interface AppTabbar_iPhone : BeeUICell

AS_SINGLETON( AppTabbar_iPhone )

AS_OUTLET( BeeUILabel, hometext );
AS_OUTLET( BeeUILabel, categorytext );
AS_OUTLET( BeeUILabel, carttext );
AS_OUTLET( BeeUILabel, usertext );

- (void)selectHome;
- (void)selectSearch;
- (void)selectCart;
- (void)selectUser;

@end
