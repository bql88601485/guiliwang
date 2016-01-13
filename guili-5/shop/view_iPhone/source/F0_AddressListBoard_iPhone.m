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
	
#import "F0_AddressListBoard_iPhone.h"
#import "F0_AddressListCell_iPhone.h"
#import "F1_NewAddressBoard_iPhone.h"
#import "F2_EditAddressBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#import "CommonNoResultCell.h"
#import "CommonPullLoader.h"

#pragma mark -

@implementation F0_AddressListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( AddressInfoModel,	addressInfoModel )
DEF_MODEL( AddressListModel,	addressListModel )

- (void)load
{
    self.shouldGotoManage = YES;
    
	self.addressInfoModel = [AddressInfoModel modelWithObserver:self];
	self.addressListModel = [AddressListModel modelWithObserver:self];
}

- (void)unload
{
	SAFE_RELEASE_MODEL( self.addressInfoModel );
	SAFE_RELEASE_MODEL( self.addressListModel );
}

ON_CREATE_VIEWS( signal )
{
    if ( self.shouldGotoManage )
    {
        self.navigationBarTitle = __TEXT(@"manage_address");
    }
    else
    {
        self.navigationBarTitle = __TEXT(@"select_address");
    }
    
    [self showNavigationBarAnimated:NO];
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
//    [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"nav_add.png"]];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setBackgroundColor:[UIColor whiteColor]];
    self.addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addButton.layer.borderWidth = 0.5;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(goAddRess) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.addButton.frame = CGRectMake(0, size.height - 44 - 65, size.width, 44);
    [self.view addSubview:self.addButton];
    
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        NSArray * addresses = [self validAddresses];
        
        self.list.total = addresses.count;
        
        if ( self.addressListModel.loaded && 0 == addresses.count )
        {
            self.list.total = 1;
            
            BeeUIScrollItem * item = self.list.items[0];
            item.clazz = [CommonNoResultCell class];
            item.size = self.list.size;
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        else
        {
            for ( int i = 0; i < addresses.count; i++ )
            {
                BeeUIScrollItem * item = self.list.items[i];
                item.clazz = [F0_AddressListCell_iPhone class];
                item.size = CGSizeAuto; 
                item.data = [addresses safeObjectAtIndex:i];
                item.rule = BeeUIScrollLayoutRule_Tile;
            }
        }
    };
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.addressListModel reload];
    };
    
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.addressListModel reload];
    
    [bee.ui.appBoard hideTabbar];

	[self.list reloadData];
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
    
}
- (void)goAddRess
{
    [self.stack pushBoard:[F1_NewAddressBoard_iPhone board] animated:YES];

}
#pragma mark - F0_AddressListCell_iPhone

/**
 * 个人中心-收货地址管理-地址列表cell，点击事件触发时执行的操作
 */
ON_SIGNAL2( F0_AddressListCell_iPhone, signal )
{
	ADDRESS * address = signal.sourceCell.data;
	
    if ( self.shouldGotoManage )
    {
		self.addressInfoModel.address_id = address.id;
		[self.addressInfoModel reload];
    }
    else
    {
        [self.addressListModel setDefault:address];
    }
}

#pragma mark -

- (NSArray *)validAddresses
{
    NSMutableArray * array = [NSMutableArray array];
    
    for ( ADDRESS * address in self.addressListModel.addresses )
    {
        if ( address.isRegionValid )
        {
            [array addObject:address];
        }
    }
    
    return array;
}

#pragma mark -

ON_MESSAGE3( API, address_list, msg )
{
	if ( msg.sending )
	{
		if ( NO == self.addressListModel.loaded )
		{
			 [self presentLoadingTips:__TEXT(@"tips_loading")];
		}
	}
	else
	{
		[self.list setHeaderLoading:NO];
		
		[self dismissTips];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{

			[self.list reloadData];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if ( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_info, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_loading")];
	}
	else
	{
		[self dismissTips];
	}

	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
            F1_NewAddressBoard_iPhone *boad = [F1_NewAddressBoard_iPhone board];
//			F2_EditAddressBoard_iPhone * board = [F2_EditAddressBoard_iPhone board];
            boad.isChange = YES;
			boad.address = self.addressInfoModel.address;
			[self.stack pushBoard:boad animated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

ON_MESSAGE3( API, address_setDefault, msg )
{
	if ( msg.sending )
	{
		[self presentLoadingTips:__TEXT(@"tips_loading")];
	}
	else
	{
		[self dismissTips];
	}
	
	if ( msg.succeed )
	{
		STATUS * status = msg.GET_OUTPUT(@"status");
		
		if ( status && status.succeed.boolValue )
		{
			[self.stack popBoardAnimated:YES];
		}
		else
		{
			[self showErrorTips:msg];
		}
	}
	else if( msg.failed )
	{
		[self showErrorTips:msg];
	}
}

@end
