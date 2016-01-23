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

#import "AppTabbar_iPhone.h"
#import "model.h"

#pragma mark -

DEF_UI( AppTabbar_iPhone, tabbar )

#pragma mark -

@implementation AppTabbar_iPhone

DEF_SINGLETON( AppTabbar_iPhone )
DEF_OUTLET(BeeUILabel, hometext);
DEF_OUTLET( BeeUILabel, categorytext );
DEF_OUTLET( BeeUILabel, carttext );
DEF_OUTLET( BeeUILabel, usertext );


SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [self observeNotification:UserModel.LOGIN];
    [self observeNotification:UserModel.LOGOUT];
    [self observeNotification:UserModel.KICKOUT];
    [self observeNotification:CartModel.UPDATED];
    
    $(@"#badge-bg").HIDE();
    $(@"#badge").HIDE();
    
    [self selectHome];
}

- (void)unload
{
    [self unobserveAllNotifications];
}

#pragma mark -

- (void)deselectAll
{
    $(@"#home-bg").HIDE();
    $(@"#cart-bg").HIDE();
    $(@"#user-bg").HIDE();
    $(@"#category-bg").HIDE();
    
    $(@"#home-button").UNSELECT();
    $(@"#cart-button").UNSELECT();
    $(@"#user-button").UNSELECT();
    $(@"#category-button").UNSELECT();
}

- (void)updateLabel:(UILabel *)lable{
    
    
    _hometext.textColor = [UIColor colorWithString:@"#5F646E"];
    _categorytext.textColor = [UIColor colorWithString:@"#5F646E"];
    _carttext.textColor = [UIColor colorWithString:@"#5F646E"];
    _usertext.textColor = [UIColor colorWithString:@"#5F646E"];
    
    
    lable.textColor = [UIColor colorWithString:@"#1a1968"];
}

- (void)selectHome
{
    [self deselectAll];
    self.selectNUm = 0;
    $(@"#home-bg").SHOW();
    $(@"#home-button").SELECT();
    
    [self updateLabel:_hometext];
    
    self.RELAYOUT();
}

- (void)selectSearch
{
    [self deselectAll];
    self.selectNUm = 1;
    $(@"#category-bg").SHOW();
    $(@"#category-button").SELECT();
    
    [self updateLabel:_categorytext];
    
    self.RELAYOUT();
}

- (void)selectCart
{
    [self deselectAll];
    self.selectNUm = 2;
    $(@"#cart-bg").SHOW();
    $(@"#cart-button").SELECT();
    
    [self updateLabel:_carttext];
    
    self.RELAYOUT();
}

- (void)selectUser
{
    [self deselectAll];
    self.selectNUm = 3;
    $(@"#user-bg").SHOW();
    $(@"#user-button").SELECT();
    
    [self updateLabel:_usertext];
    
    self.RELAYOUT();
}

#pragma mark -

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
    self.data = @(0);
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
    self.data = @(0);
}

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
    NSUInteger count = 0;
    
    for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
    {
        count += goods.goods_number.intValue;
    }
    
    self.data = @(count);
}

ON_NOTIFICATION3( CartModel, UPDATED, notification )
{
    NSUInteger count = 0;
    
    for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
    {
        count += goods.goods_number.intValue;
    }
    
    self.data = @(count);
}

#pragma mark -

- (void)dataDidChanged
{
    NSNumber * count = self.data;
    
    if ( count && count.intValue > 0 )
    {
        $(@"#badge-bg").SHOW();
        $(@"#badge").SHOW().BIND_DATA( count );
    }
    else
    {
        $(@"#badge-bg").HIDE();
        $(@"#badge").HIDE();
    }
    
    
}

@end
