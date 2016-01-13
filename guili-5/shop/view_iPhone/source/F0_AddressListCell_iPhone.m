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

#import "F0_AddressListCell_iPhone.h"

#pragma mark -

@implementation F0_AddressListCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        ADDRESS * address = self.data;
        
        NSString *addreStr = [NSString stringWithFormat:@"%@ %@ %@ %@",address.province_name,address.city_name,address.district_name,address.address];
        
        NSString *phoneNum = address.mobile;
        
        $(@"#name").TEXT( address.consignee );
        $(@"#location").TEXT( phoneNum );
        $(@"#location-detail").TEXT( addreStr );
        if ( address.default_address.boolValue )
        {
            $(@"#location-defult").TEXT (@"[默认]");
            $(@"#location-defult").CSS(@"color: #de2b00");
            $(@"#location-defult").CSS(@"width:40");
            $(@"#list-indictor").SHOW();
            $(@"#name").CSS(@"color: #2097C8");
            //            $(@"#location").CSS(@"color: #2097C8");
            //            $(@"#location-detail").CSS(@"color: #2097C8");
        }
        else
        {
            $(@"#location-defult").CSS(@"width:0");
            $(@"#list-indictor").HIDE();
            $(@"#name").CSS(@"color: #333");
            //            $(@"#location").CSS(@"color: #333");
            //            $(@"#location-detail").CSS(@"color: #333");
        }
    }
}

@end
