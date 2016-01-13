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
	
#import "F1_NewAddressBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "F3_RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "F1_NewAddressCell_iPhone.h"
#import "C1_CheckOutBoard_iPhone.h"


#import "AddressChoicePickerView.h"
#pragma mark -


#define KEY_MAIL        @"test@163.com"

@implementation F1_NewAddressBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( AddressListModel,	addressListModel )
DEF_MODEL( RegionModel,			regionModel )

DEF_SIGNAL( DELETE_CONFIRM )

- (void)load
{
    self.shouldShowMessage = NO;
    self.isShopingCartBord = NO;
	self.addressListModel = [AddressListModel modelWithObserver:self];
    self.regionModel = [RegionModel modelWithObserver:self];
    
    if (_isChange) {
        
    }else{
        self.address = [[[ADDRESS alloc] init] autorelease];
    }
   
    
}

- (void)unload
{
    self.address = nil;
    
	SAFE_RELEASE_MODEL( self.addressListModel )
	SAFE_RELEASE_MODEL( self.regionModel )
}

#pragma mark - action
- (void)DelAddress{
    
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    alert.title = @"是否删除地址?";
    [alert addButtonTitle:@"确定" signal:self.DELETE_CONFIRM];
    [alert addCancelTitle:@"取消"];
    [alert showInViewController:self];
}
- (void)setDefulatAddess{

    if ( [self checked] )
    {
        [self.view endEditing:YES];
        
        [self.addressListModel setDefault:self.address];
    }

}

- (BOOL)checked
{
    UIView * item = ((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == item )
        return NO;
    
    NSString * name = $(item).FIND(@"name").text;
    NSString * tel = $(item).FIND(@"tel").text;
    NSString * email = $(item).FIND(@"email").text;
    if (nil == email) {
        if (self.address.email.length == 0) {
            email = @"test@163.com";
        }else{
            email = self.address.email;
        }
    }
    NSString * zipcode = $(item).FIND(@"zipcode").text;
    NSString * tempAddress = $(item).FIND(@"address").text;
    
    // 输入不正确显示光标
    if ( !( name && name.length ) )
    {
        $(item).FIND(@"#name").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_recipient")];
        return NO;
    }
    
    if ( tel.length < 6 )
    {
        $(item).FIND(@"#tel").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
        return NO;
    }

    
    if ( !(zipcode && zipcode.length ) )
    {
        $(item).FIND(@"#zipcode").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_zipcode")];
        return NO;
    }
    
    if ( !( tempAddress && tempAddress.length ) )
    {
        $(item).FIND(@"#address").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_address")];
        return NO;
    }
    
    if ( !self.address.isRegionValid )
    {
        [self presentFailureTips:__TEXT(@"warn_no_region")];
        return NO;
    }
    
    self.address.tel = tel;
    self.address.email = email;
    self.address.zipcode = zipcode;
    self.address.consignee = name;
    self.address.address = tempAddress;
    self.address.city = self.address.city ? : @(0);
    self.address.country = self.address.country ? : @(0);
    self.address.province = self.address.province ? : @(0);
    self.address.district = self.address.district ? : @(0);
    
    return YES;
}


ON_CREATE_VIEWS( signal )
{
//    [self setTitleString:__TEXT(@"address_add")];
//    [self showNavigationBarAnimated:NO];
    self.navigationBarShown = YES;
    if (_isChange) {
        self.navigationBarTitle = __TEXT(@"modify_address");
    }else{
      self.navigationBarTitle = __TEXT(@"address_add");
    }
    
    
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav_back.png"]];
    
    [self showBarButton:BeeUINavigationBar.RIGHT title:@"保存"];
    
    @weakify(self);
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.clazz = [F1_NewAddressCell_iPhone class];
        item.size = self.list.size;
        item.data = self.address;
        item.rule = BeeUIScrollLayoutRule_Tile;
    };
    
    [self observeNotification:BeeUIKeyboard.HIDDEN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.SHOWN];
    
    if (_isChange) {
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(-1, size.height - 40 - 65, size.width + 2, 42)];
        self.footView.backgroundColor = [UIColor whiteColor];
        self.footView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.footView.layer.borderWidth = 0.5;
        [self.view  addSubview:self.footView];
        
        
        UIButton *buttonDel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDel.frame = CGRectMake(0, 0, size.width/2, 40);
        [buttonDel setBackgroundColor:[UIColor clearColor]];
        buttonDel.titleLabel.font = [UIFont systemFontOfSize:14];
        [buttonDel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [buttonDel setTitle:@"删除地址" forState:UIControlStateNormal];
        [buttonDel addTarget:self action:@selector(DelAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:buttonDel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 1, 42/2 - 20/2, 0.5, 20)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.footView addSubview:line];
        
        
        UIButton *buttonDefult = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDefult.frame = CGRectMake(size.width/2, 0, size.width/2, 40);
        [buttonDefult setBackgroundColor:[UIColor clearColor]];
        buttonDefult.titleLabel.font = [UIFont systemFontOfSize:14];
        [buttonDefult setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonDefult addTarget:self action:@selector(setDefulatAddess) forControlEvents:UIControlEventTouchUpInside];
        [buttonDefult setTitle:@"设置默认" forState:UIControlStateNormal];
        [self.footView addSubview:buttonDefult];
        
    }
    
    
    
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [bee.ui.appBoard hideTabbar];
}

ON_DID_APPEAR( signal )
{
    if ( self.shouldShowMessage )
    {
        [self presentMessageTips:__TEXT(@"non_address")];
    }
    
    [self.list reloadData];
    
    UIView * item = ((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == item )
		return;
    
    if (_isChange) {
        $(item).FIND(@"name").DATA( self.address.consignee );
        $(item).FIND(@"tel").DATA( self.address.tel );
        $(item).FIND(@"zipcode").DATA( self.address.zipcode );
        
        NSString *addreStr = [NSString stringWithFormat:@"%@ %@ %@ %@",_address.country_name,_address.province_name,_address.city_name,_address.district_name];
        
        $(item).FIND(@"location-label").DATA( addreStr);
        $(item).FIND(@"address").DATA( self.address.address );
        
        
        
    }else{
        $(item).FIND(@"#location-label").TEXT( self.address.region );
        
        $(item).FIND(@"tel").DATA( self.address.region );
    }
    
    
    
}

ON_WILL_DISAPPEAR( signal )
{
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
    [self.stack popBoardAnimated:YES];
}
ON_RIGHT_BUTTON_TOUCHED( signal )
{
    if (_isChange) {
        if ( [self checked] )
        {
            [self.view endEditing:YES];
            
            [self.addressListModel update:self.address];
        }
    }else{
        [self doSave];
    }
    
}
#pragma mark - BeeUITextField

ON_SIGNAL3( BeeUITextField, RETURN, signal )
{
    F1_NewAddressCell_iPhone * item = (F1_NewAddressCell_iPhone *)signal.sourceCell;
    BeeUITextField * input = (BeeUITextField *)signal.source;

    if( $(item).FIND(@"#name").focusing )
    {
        $(item).FIND(@"#tel").FOCUS();
        return;
    }
    else if( $(item).FIND(@"#tel").focusing )
    {
        $(item).FIND(@"#email").FOCUS();
        return;
    }
    else if ( $(item).FIND(@"#zipcode").focusing )
    {
        $(item).FIND(@"#address").FOCUS();
        return;
    }
    else if ( UIReturnKeyDone == input.returnKeyType )
    {
        [self.view endEditing:YES];
    }
}

#pragma mark - F1_NewAddressCell_iPhone

ON_SIGNAL3( F1_NewAddressCell_iPhone, location, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		self.regionModel.parent_id = @(0);
        
         [self.view endEditing:NO];
        
        
        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
        addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
            
            self.address.country = locate.regionID;
            self.address.country_name = locate.region;
            self.address.province = locate.provinceID;
            self.address.province_name = locate.province;
            self.address.city = locate.cityID;
            self.address.city_name = locate.city;
            self.address.district = locate.areaID;
            self.address.district_name = locate.area;
            
            [self setLocationText:[self.address region]];

        };
        [addressPickerView show];
        
    }
}

ON_SIGNAL3( F1_NewAddressCell_iPhone, add, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self doSave];
    }
}

#pragma mark - BeeUIKeyboard

ON_NOTIFICATION3( BeeUIKeyboard, SHOWN, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;

    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HEIGHT_CHANGED, notification )
{
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;

    [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
}

ON_NOTIFICATION3( BeeUIKeyboard, HIDDEN, notification )
{
    [self.list setBaseInsets:UIEdgeInsetsZero];
}

#pragma mark -

- (void)setLocationText:(NSString *)text
{
    UIView * onlyChild = ((BeeUIScrollItem *)self.list.items[0]).view;
    $(onlyChild).FIND(@"#location-label").TEXT(text);
}

- (void)doSave
{
    UIView * item = ((BeeUIScrollItem *)self.list.items[0]).view;
    if ( nil == item )
		return;

    NSString * name = $(item).FIND(@"name").text;
    NSString * tel = $(item).FIND(@"tel").text;
    NSString * zipcode = $(item).FIND(@"zipcode").text;
    NSString * tempAddress = $(item).FIND(@"address").text;

	// 输入不正确显示光标
    if ( !( name && name.length ) )
    {
		$(item).FIND(@"#name").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_recipient")];
        return;
    }
    
    if ( tel.length < 6 )
    {
		$(item).FIND(@"#tel").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_mobile")];
        return;
    }
    
    if ( !( KEY_MAIL && KEY_MAIL.length && KEY_MAIL.isEmail ) )
    {
		$(item).FIND(@"#email").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_email")];
        return;
    }
    
	if ( !(zipcode && zipcode.length ) )
	{
		$(item).FIND(@"#zipcode").FOCUS();
		[self presentFailureTips:__TEXT(@"warn_no_zipcode")];
		return;
	}
	
    if ( !( tempAddress && tempAddress.length ) )
    {
		$(item).FIND(@"#address").FOCUS();
        [self presentFailureTips:__TEXT(@"warn_no_address")];
        return;
    }
    
    if ( !self.address.isRegionValid )
    {
        [self presentFailureTips:__TEXT(@"warn_no_region")];
        return;
    }
    
    ADDRESS * address = [[[ADDRESS alloc] init] autorelease];
    address.tel = tel;
    address.mobile = tel;
    address.email = KEY_MAIL;
    address.zipcode = zipcode;
    address.consignee = name;
    address.address = tempAddress;
    address.city = self.address.city;
    address.country = self.address.country;
    address.province = self.address.province;
    address.district = self.address.district;

    [self.addressListModel add:address];
}

#pragma mark -

ON_MESSAGE3( API, region, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
			@weakify(self);
			
			F3_RegionPickBoard_iPhone * board = [[[F3_RegionPickBoard_iPhone alloc] init] autorelease];
			board.rootBoard = self;
			board.regions = self.regionModel.regions;
			
			board.whenRegionChanged = ^(ADDRESS * address)
			{
				@normalize(self);
				
				[self.address setRegionValueWithAddress:address];
				[self setLocationText:[address region]];
			};
			
			[self.stack pushBoard:board animated:YES];
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

ON_MESSAGE3( API, address_add, msg )
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
		STATUS * status = msg.GET_OUTPUT( @"status" );
		
		if ( status.succeed.boolValue )
		{
            if(self.isShopingCartBord) {
                //[self.stack popBoardAnimated:YES];
                C1_CheckOutBoard_iPhone * board = [C1_CheckOutBoard_iPhone board];
                board.shopingCartBod=self.shopingCartBod;
                [self.stack pushBoard:board animated:YES];
            }else
            {
                [self.stack popBoardAnimated:YES];
            }
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

ON_MESSAGE3( API, address_update, msg )
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
        STATUS * status = msg.GET_OUTPUT( @"status" );
        
        if ( status.succeed.boolValue )
        {
            [self.view.window presentSuccessTips:__TEXT(@"address_updated")];
            
            [self.stack popBoardAnimated:YES];
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


ON_MESSAGE3( API, address_delete, msg )
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
        STATUS * status = msg.GET_OUTPUT( @"status" );
        
        if ( status.succeed.boolValue )
        {
            [self.stack popBoardAnimated:YES];
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
        STATUS * status = msg.GET_OUTPUT( @"status" );
        
        if ( status.succeed.boolValue )
        {
            [self.view.window presentSuccessTips:__TEXT(@"address_selected")];
            
            [self.stack popBoardAnimated:YES];
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


/**
 * 收货地址管理-修改收货地址-删除地址，确认删除地址事件触发时执行的操作
 */
ON_SIGNAL3( F1_NewAddressBoard_iPhone, DELETE_CONFIRM, signal )
{
    [self.addressListModel remove:self.address];
}

@end
