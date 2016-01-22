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

#import "B0_IndexBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "B1_ProductListBoard_iPhone.h"
#import "B2_ProductDetailBoard_iPhone.h"
#import "H0_BrowserBoard_iPhone.h"
#import "G1_HelpBoard_iPhone.h"

#import "CommonFootLoader.h"
#import "CommonPullLoader.h"

#import "B0_BannerCell_iPhone.h"
#import "B0_IndexRecommendCell_iPhone.h"
#import "B0_IndexCategoryCell_iPhone.h"
#import "D0_SearchInput_iPhone_new.h"
#import "IndexCategoryTabCell.h"
#import "IndexBannerCell.h"
#import "B0_IndexRecommendGoodsCell_iPhone.h"
#import "B0_IndexCategoryCell_iPhoneTwo.h"
#import "B0_IndexCategoryCell_iPhoneOne.h"
#import "WebViewController.h"
#import "B0_IndexCategoryCell_iPhone_3.h"
#import "B0_IndexCategoryCell_iPhoneOne_1.h"
#import "B0_IndexCategoryCell_iPhoneTwo_2.h"
#pragma mark -

@interface B0_IndexBoard_iPhone()
{
    NSMutableArray *newCargories;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * _line;
}

@end

@implementation B0_IndexBoard_iPhone

DEF_INT( ACTION_ADD,    1)
DEF_INT( ACTION_BUY,    2)
DEF_INT( ACTION_SPEC,   3)

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_MODEL( BannerModel,		bannerModel );
DEF_MODEL( CategoryModel,	categoryModel );

DEF_OUTLET( BeeUIScrollView, list )

DEF_OUTLET( BeeUITextField, search_input);


#pragma mark -

- (void)load
{
    self.isHome = YES;
    self.bannerModel	= [BannerModel modelWithObserver:self];
    self.categoryModel	= [CategoryModel modelWithObserver:self];
}

- (void)unload
{
    self.bannerModel	= nil;
    self.categoryModel	= nil;
}

#pragma mark -

ON_CREATE_VIEWS( signal )
{
    self.navigationBarShown = YES;
    [self showNavigationBarAnimated:NO];
    //self.navigationBarTitle = __TEXT(@"ecmobile");
    
    /**
     * BeeFramework中scrollView使用方式由0.4.0改为0.5.0
     * 将board中BeeUIScrollView对应的signal转换为block的实现方式
     * BeeUIScrollView的block方式写法可以从它对应的delegate方法中转换而来
     */
    
    self.isHome = YES;
    self.search_input.delegate = self;
    self.search_input.text = @"贵州 礼品";
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        //        [UIView animateWithDuration:0.2 animations:^{
        //            [self.view setTop:20];
        //        }];
        
        [self.view setTop:20];
        
        self.list.total = self.bannerModel.banners.count ? 1 : 0;
        self.list.total += self.bannerModel.goods.count ? 1 : 0;
        self.list.total+=1;//分类
        self.list.total+=1;//积分商城
        
        
        int offset = 0;
        
        if ( self.bannerModel.banners.count )
        {
            BeeUIScrollItem * banner = self.list.items[offset];
            banner.clazz = [B0_BannerCell_iPhone class];
            banner.data = self.bannerModel.banners;
            banner.size = CGSizeMake( self.list.width, 150.0f);
            banner.rule = BeeUIScrollLayoutRule_Line;
            banner.insets = UIEdgeInsetsMake(0, 0, 0, 0);
            
            offset += 1;
        }
        
        BeeUIScrollItem * categories = self.list.items[offset];
        categories.clazz = [IndexCategoryTabCell class];
        categories.data = nil;
        categories.size = CGSizeMake(self.list.width, 165); // TODO:分类
        categories.rule = BeeUIScrollLayoutRule_Line;
        categories.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        categories.view.backgroundColor = [UIColor whiteColor];
        
        offset += 1;
        BeeUIScrollItem * banner = self.list.items[offset];
        banner.clazz = [IndexBannerCell class];
        banner.data = nil;
        banner.size = CGSizeAuto; // TODO:
        banner.rule = BeeUIScrollLayoutRule_Line;
        banner.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        banner.view.backgroundColor = [UIColor whiteColor];
        
        offset += 1;
        //        if ( self.bannerModel.goods.count )
        //        {
        //            BeeUIScrollItem * recommendGoods = self.list.items[offset];
        //            recommendGoods.clazz = [B0_IndexRecommendCell_iPhone class];
        //            recommendGoods.data = self.bannerModel.goods;
        //            recommendGoods.size = CGSizeAuto; // TODO:
        //            recommendGoods.rule = BeeUIScrollLayoutRule_Line;
        //            recommendGoods.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        //            
        //            offset += 1;
        //        }
        
        
        //分类
        NSMutableArray *allData = [[NSMutableArray alloc] init];
        
        for (CATEGORY *objec in self.categoryModel.categories) {
            
            newCargories = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3", nil];
            
            
            for (SIMPLE_GOODS *item in objec.goods) {
                
                NSString *seller_note = item.seller_note;
                
                NSArray *tmp = [seller_note componentsSeparatedByString:@"|"];
                
                [self dataYh:tmp :[[tmp firstObject] intValue]-1 :item];
            }
            
            int change = 0;
            
            for (NSArray *list in newCargories) {
                
                if ([list isKindOfClass:[NSArray class]]) {
                    CATEGORY *tmpObject = [[CATEGORY alloc] init];
                    tmpObject.id = objec.id;
                    tmpObject.name = objec.name;
                    tmpObject.goods = list;
                    tmpObject.change = change;
                    [allData addObject:tmpObject];
                    change++;
                }
            }
        }
        
        self.list.total += allData.count;
        
        
        for ( int i = 0; i < allData.count; i++ )
        {
            BeeUIScrollItem * categoryItem = self.list.items[ i + offset ];
            CATEGORY *object = [allData safeObjectAtIndex:i];
            if (object.goods.count == 1) {
                if (object.change > 0) {
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhoneOne_1 class];
                    categoryItem.size = CGSizeMake( self.list.width, 170.0f );
                }else{
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhoneOne class];
                    categoryItem.size = CGSizeMake( self.list.width, 190.0f );
                }
            }else if (object.goods.count == 2){
                if (object.change > 0) {
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhoneTwo_2 class];
                    categoryItem.size = CGSizeMake( self.list.width, 170.0f );
                }else{
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhoneTwo class];
                    categoryItem.size = CGSizeMake( self.list.width, 190.0f );
                }
            }else if (object.goods.count == 3){
                if (object.change > 0) {
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhone_3 class];
                    categoryItem.size = CGSizeMake( self.list.width, 170.0f );
                }else{
                    categoryItem.clazz = [B0_IndexCategoryCell_iPhone class];
                    categoryItem.size = CGSizeMake( self.list.width, 190.0f );
                }
            }
            
            categoryItem.data = object;
            categoryItem.rule = BeeUIScrollLayoutRule_Line;
            categoryItem.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        offset += self.categoryModel.categories.count;
        
        
        
    };
    self.list.whenHeaderRefresh = ^
    {
        [self.bannerModel reload];
        [self.categoryModel reload];
        
        [[CartModel sharedInstance] reload];
    };
    
}

- (void)dataYh:(NSArray *)tmp :(NSUInteger )num :(id)item{
    
    NSMutableArray *tmepArray = [newCargories objectAtIndex:num];
    if ([tmepArray isKindOfClass:[NSMutableArray class]]) {
    }else{
        tmepArray = [[NSMutableArray alloc] init];
    }
    
    [newCargories removeObjectAtIndex:num];
    
    [tmepArray addObject:item];
    
    [newCargories insertObject:tmepArray atIndex:num];
}

ON_DELETE_VIEWS( signal )
{
    self.list = nil;
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )//导航
{
    //[self.list reloadData];
    
    [bee.ui.appBoard showTabbar];
    
    D0_SearchInput_iPhone_new * searchBar = [[D0_SearchInput_iPhone_new alloc] initWithFrame:CGRectMake(0, 0., self.view.width, 44.0f)];
    
    self.titleView = searchBar;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setTop:20];
    });
    
    [self.search_input resignFirstResponder];
}
ON_SIGNAL2( UIView, signal ){
    
    
    [self    cancelText];
    
}
- (void)doIntro:(NSString *)keyword
{
    
    if ( keyword.length )
    {
        B1_ProductListBoard_iPhone * board = [[[B1_ProductListBoard_iPhone alloc] init] autorelease];
        board.searchByHotModel.filter.intro = keyword;
        board.searchByCheapestModel.filter.intro = keyword;
        board.searchByExpensiveModel.filter.intro = keyword;
        board.isfromHome = YES;
        [self.stack pushBoard:board animated:YES];
    }
}
- (void)doSearch:(NSString *)keyword
{
    $(self.navigationBarTitle).FIND( @"search-input" ).TEXT( keyword );
    
    if ( keyword.length )
    {
        B1_ProductListBoard_iPhone * board = [[[B1_ProductListBoard_iPhone alloc] init] autorelease];
        board.searchByHotModel.filter.keywords = keyword;
        board.searchByCheapestModel.filter.keywords = keyword;
        board.searchByExpensiveModel.filter.keywords = keyword;
        board.isfromHome = YES;
        [self.stack pushBoard:board animated:YES];
    }
}
#pragma textfield Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self doSearch:textField.text];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *sea=textField.text;
    if ([sea isEqualToString:@"贵州 礼品"]) {
        textField.text = @"";
    }
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * fieldText = [NSString stringWithFormat:@"%@%@", textField.text , string];
    if(fieldText.length > 20){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
ON_DID_APPEAR( signal )
{
    [self.list reloadData];
    if ( NO == self.bannerModel.loaded )
    {
        [self.bannerModel reload];
    }
    
    if ( NO == self.categoryModel.loaded )
    {
        [self.categoryModel reload];
    }
    
    
}

ON_WILL_DISAPPEAR( signal )
{
    [CartModel sharedInstance].loaded = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_LOAD_DATAS( signal )
{
    [self.bannerModel loadCache];
    [self.categoryModel loadCache];
}

#pragma mark -

ON_LEFT_BUTTON_TOUCHED( signal )
{
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark - B0_BannerPhotoCell_iPhone

/**
 * 首页-banner，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_BannerPhotoCell_iPhone, mask, signal )
{
    BANNER * banner = signal.sourceCell.data;
    
    if ( banner )
    {
        NSRange findHttp = [banner.url rangeOfString:@"http://goods/"];
        
        if (findHttp.location != NSNotFound) {
            
            NSString *newUrl = [banner.url stringByReplacingOccurrencesOfString:@"http://goods/" withString:@""];
            
            NSArray *tmplist = [newUrl componentsSeparatedByString:@","];
            
            if (tmplist.count == 1) {
                B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
                board.goodsModel.goods_id = [NSNumber numberWithFloat:[[tmplist firstObject] floatValue]];
                [self.stack pushBoard:board animated:YES];
                return;
            }else if (tmplist.count >= 2){
                
                
                B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
                board.category = @"发现";
                board.isfromHome = YES;
                board.isfromBanner = YES;
                board.kids = newUrl;
                [self.stack pushBoard:board animated:YES];
                
                
                return;
            }
        }
        
        if ( [banner.action isEqualToString:BANNER_ACTION_GOODS] )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_BRAND] )
        {
            B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
            board.searchByHotModel.filter.brand_id = banner.action_id;
            board.searchByCheapestModel.filter.brand_id = banner.action_id;
            board.searchByExpensiveModel.filter.brand_id = banner.action_id;
            board.isfromHome = YES;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_CATEGORY] )
        {
            B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
            board.category = banner.description;
            board.searchByHotModel.filter.category_id = banner.action_id;
            board.searchByCheapestModel.filter.category_id = banner.action_id;
            board.searchByExpensiveModel.filter.category_id = banner.action_id;
            board.isfromHome = YES;
            [self.stack pushBoard:board animated:YES];
        }
        else
        {
            H0_BrowserBoard_iPhone * board = [[[H0_BrowserBoard_iPhone alloc] init] autorelease];
            board.defaultTitle = banner.description.length ? banner.description : __TEXT(@"new_activity");
            board.urlString = banner.url;
            [self.stack pushBoard:board animated:YES];
        }
        
    }
}

#pragma mark - B0_IndexCategoryCell_iPhone

/**
 * 首页-分类商品-分类，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, CATEGORY_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
        board.category = category.name;
        board.searchByHotModel.filter.category_id = category.id;
        board.searchByCheapestModel.filter.category_id = category.id;
        board.searchByExpensiveModel.filter.category_id = category.id;
        board.isfromHome = YES;
        [self.stack pushBoard:board animated:YES];
    }
}

/**
 * 首页-分类商品-商品1，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, GOODS1_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:0];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}

/**
 * 首页-分类商品-商品2，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, GOODS2_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:1];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhone, GOODS3_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:2];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}
//sss

/**
 * 首页-分类商品-商品2，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneTwo, GOODS1_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:0];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneTwo, GOODS2_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:1];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}



//ss
ON_SIGNAL3( B0_IndexCategoryCell_iPhoneOne, GOODS1_TOUCHED, signal )
{
    CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
    {
        SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:0];
        
        if ( goods )
        {
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}



ON_SIGNAL3( IndexCategoryTabCell, seasoning_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"特色调料";
    board.searchByHotModel.filter.category_id =@(140);
    board.searchByCheapestModel.filter.category_id = @(140);
    board.searchByExpensiveModel.filter.category_id = @(140);
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, tea_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"有机茶叶";
    board.searchByHotModel.filter.category_id =@(138);
    board.searchByCheapestModel.filter.category_id = @(138);
    board.searchByExpensiveModel.filter.category_id = @(138);
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, food_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"原生食品";
    board.searchByHotModel.filter.category_id =@(139);
    board.searchByCheapestModel.filter.category_id = @(139);
    board.searchByExpensiveModel.filter.category_id = @(139);
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, drink_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"酒类直供";
    board.searchByHotModel.filter.category_id =@(137);
    board.searchByCheapestModel.filter.category_id = @(137);
    board.searchByExpensiveModel.filter.category_id = @(137);
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, health_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"养生保健";
    board.searchByHotModel.filter.category_id =@(141);
    board.searchByCheapestModel.filter.category_id = @(141);
    board.searchByExpensiveModel.filter.category_id = @(141);
    board.isfromHome = YES;
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, art_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"艺术收藏";
    board.searchByHotModel.filter.category_id =@(122);
    board.searchByCheapestModel.filter.category_id = @(122);
    board.searchByExpensiveModel.filter.category_id = @(122);
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
}
#pragma mark - B0_IndexRecommendGoodsCell_iPhone

/**
 * 首页-推荐商品，点击事件触发时执行的操作
 */
ON_SIGNAL3( B0_IndexRecommendGoodsCell_iPhone, mask, signal )
{
    
    B0_IndexRecommendGoodsCell_iPhone * item = (B0_IndexRecommendGoodsCell_iPhone *)signal.sourceCell;
    NSString *title= $(item).FIND(@"#title").text;
    if ([title isEqualToString:@"疯狂抢购"]) {
        [self doIntro:@"promotion"];
    }
    if ([title isEqualToString:@"热卖商品"]) {
        [self doIntro:@"hot"];
    }
    if ([title isEqualToString:@"热评商品"]) {
        [self doIntro:@"best"];
    }
    if ([title isEqualToString:@"新品上架"]) {
        [self doIntro:@"new"];
    }
    /*SIMPLE_GOODS * goods = signal.sourceCell.data;
     
     if ( goods )
     {
	    B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
     board.goodsModel.goods_ id = goods.id;
     [self.stack pushBoard:board animated:YES];
     }*/
}
ON_SIGNAL3(IndexBannerCell, XQ_button, signal){
    WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.stack pushBoard:web animated:YES];
}
#pragma mark -

ON_MESSAGE3( API, home_data, msg )
{
    if ( msg.sending )
    {
        //		if ( NO == self.bannerModel.loaded && 0 == self.bannerModel.banners.count )
        //		{
        //			[self presentLoadingTips:__TEXT(@"tips_loading")];
        //		}
    }
    else
    {
        [self.list setHeaderLoading:NO];
        
        [self dismissTips];
        
        if ( msg.succeed )
        {
            [self.list asyncReloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.list asyncReloadData];
            });
        }
        else if ( msg.failed )
        {
            [self showErrorTips:msg];
        }
    }
}

ON_MESSAGE3( API, home_category, msg )
{
    if ( msg.sending )
    {
        //		if ( NO == self.categoryModel.loaded && 0 == self.categoryModel.categories.count )
        //		{
        //			[self presentLoadingTips:__TEXT(@"tips_loading")];
        //		}
    }
    else
    {
        [self.list setHeaderLoading:NO];
        
        [self dismissTips];
        
        if ( msg.succeed )
        {
            [self.list asyncReloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.list asyncReloadData];
            });
        }
        else if ( msg.failed )
        {
            [self showErrorTips:msg];
        }
    }
}
ON_SIGNAL3( D0_SearchInput_iPhone_new, sear_button, signal ){
    [UIView animateWithDuration:0.2 animations:^{
        if (self.view.top == 20) {
            self.view.top = 64;
        }else{
            [self.search_input resignFirstResponder];
            self.view.top = 20;
        }
    }];
}
ON_SIGNAL3( D0_SearchInput_iPhone_new, home_button, signal ){
    
    if ( NO == [UserModel online] )
    {
        [bee.ui.appBoard showLogin];
        return;
    }
    
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    reader.showsHelpOnFail = NO;
    //        reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    //        [reader.view setFrame:CGRectMake(0, 20 + 44, self.view.bounds.size.width, self.view.frame.size.height)];
    
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    NSLog(@"reader.view = %@",reader.view.subviews);
    UIView * downView = [reader.view.subviews firstObject];
    for (UIView * vi in reader.view.subviews) {
        if(vi.frame.origin.y > downView.frame.origin.y){
            downView = vi;
        }
    }
    UIView * rightView = [downView.subviews.firstObject subviews].firstObject;
    NSLog(@"[downView.subviews.firstObject subviews] = %@",[downView.subviews.firstObject subviews]);
    for(UIView * vi in [downView.subviews.firstObject subviews]){
        if(vi.frame.origin.x > rightView.frame.origin.y){
            rightView = vi;
        }
    }
    [rightView setHidden:YES];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 50)];
    label.text = @"请将扫描的二维码至于下面的框内";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"PEPhotoCropEditorBorder"] stretchableImageWithLeftCapWidth:23/2 topCapHeight:23/2]];
    image.frame = CGRectMake(20, 110, 280, 280);
    [view addSubview:image];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    NSLog(@"navig =%@",self.navigationController);
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
}

- (void)cancelText{
    [self.search_input resignFirstResponder];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [navigationController.navigationBar setBackgroundImage:[self
                                                            imageWithColor:[UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]
                                                            size:CGSizeMake(self.view.frame.size.width, 44)]
                                             forBarMetrics:UIBarMetricsDefault];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIColor blackColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset,
                                               [UIFont boldSystemFontOfSize:22],UITextAttributeFont, nil];
    
    [navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, .0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGContextFillRect(context, CGRectMake(.0, .0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    if ([predicate evaluateWithObject:symbol.data]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:symbol.data]];
    }
    else {
        //[UserModel sharedInstance].session.member=symbol.data;
        [[BeeFileCache sharedInstance] setObject:symbol.data forKey:@"qrcodedata"];
        [self addToCart:self.ACTION_ADD];
        //[self doSearch:symbol.data];
    }
}
- (void)addToCart:(NSUInteger)action
{
    
}


@end
