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

#import "PHOTO+AutoSelection.h"
#import "SettingModel.h"

#pragma mark -

@implementation PHOTO(AutoSelection)

- (NSString *)largeURL
{
	if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_AUTO )
	{
        
        
        return self.img ? self.img : (self.url ? self.url : self.thumb);
        
//		if ( [BeeReachability isReachableViaWIFI] )
//		{
//			return self.img ? self.img : (self.url ? self.url : self.thumb);
//		}
//		else
//		{
//			return self.thumb ? self.thumb : self.small;
//		}
	}
	else if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_HIGH )
	{
		return self.img ? self.img : (self.url ? self.url : self.thumb);
	}
	else
	{
		return self.thumb ? self.thumb : (self.url ? self.url : self.img);
	}
}

- (NSString *)thumbURL
{
    return self.thumb ? self.thumb : self.small;
    
//	if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_AUTO )
//	{
//        
//        return self.thumb ? self.thumb : self.small;
//        
////		if ( [BeeReachability isReachableViaWIFI] )
////		{
////			return self.thumb ? self.thumb : self.small;
////		}
////		else
////		{
////			return self.small ? self.small : self.thumb;
////		}
//	}
//	else if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_HIGH )
//	{
//		return self.thumb ? self.thumb : self.small;
//	}
//	else
//	{
//		return self.small ? self.small : self.thumb;
//	}
}

@end
