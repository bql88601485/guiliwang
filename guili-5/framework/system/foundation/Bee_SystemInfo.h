//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "Bee_Precompile.h"
#import "Bee_Package.h"
#import "Bee_SystemConfig.h"
#import "Bee_SystemPackage.h"

#pragma mark -

AS_PACKAGE( BeePackage_System, BeeSystemInfo, info );

#pragma mark -

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)


#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



#define IOS8_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
#define IOS7_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
#define IOS6_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
#define IOS5_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
#define IOS4_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0"))
#define IOS3_OR_LATER		(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.0"))

#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )

#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS7_OR_LATER		(NO)
#define IOS6_OR_LATER		(NO)
#define IOS5_OR_LATER		(NO)
#define IOS4_OR_LATER		(NO)
#define IOS3_OR_LATER		(NO)

#define IS_SCREEN_4_INCH	(NO)
#define IS_SCREEN_35_INCH	(NO)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@interface BeeSystemInfo : NSObject

AS_SINGLETON( BeeSystemInfo )

+ (NSString *)OSVersion;
+ (NSString *)appVersion;
+ (NSString *)appShortVersion;
+ (NSString *)appIdentifier;
+ (NSString *)appSchema;
+ (NSString *)appSchema:(NSString *)name;
+ (NSString *)deviceModel;
+ (NSString *)deviceUUID;

+ (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);
+ (NSString *)jailBreaker	NS_AVAILABLE_IOS(4_0);

+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;

+ (BOOL)requiresPhoneOS;

+ (BOOL)isPhone;
+ (BOOL)isPhone35;
+ (BOOL)isPhoneRetina35;
+ (BOOL)isPhoneRetina4;
+ (BOOL)isPad;
+ (BOOL)isPadRetina;
+ (BOOL)isScreenSize:(CGSize)size;

@end
