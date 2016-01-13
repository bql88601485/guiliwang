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
#pragma mark -

@interface B0_IndexBoard_iPhone()
{
    NSMutableArray *newCargories;
    NSMutableArray *onelist;
    NSMutableArray *twolist;
    NSMutableArray *threelist;
}

@end

@implementation B0_IndexBoard_iPhone

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_MODEL( BannerModel,		bannerModel );
DEF_MODEL( CategoryModel,	categoryModel );

DEF_OUTLET( BeeUIScrollView, list )

#pragma mark -

- (void)load
{
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
    
    @weakify(self);
    
    self.list.headerClass = [CommonPullLoader class];
    self.list.headerShown = YES;
    
    self.list.lineCount = 1;
    self.list.animationDuration = 0.25f;
    
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
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
        categories.size = CGSizeMake(self.list.width, 160); // TODO:分类
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
            
            newCargories = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
            
            onelist = [[NSMutableArray alloc] init];
            twolist = [[NSMutableArray alloc] init];
            threelist = [[NSMutableArray alloc] init];
            
            for (SIMPLE_GOODS *item in objec.goods) {
                
                NSString *seller_note = item.seller_note;
                
                NSArray *tmp = [seller_note componentsSeparatedByString:@"|"];
                
                if ([[tmp firstObject] intValue] == 1) {
                    [self dataYh:tmp :0 :item];
                }else if ([[tmp firstObject] intValue] == 2){
                    [self dataYh:tmp :1 :item];
                }else if ([[tmp firstObject] intValue] == 3){
                    [self dataYh:tmp :2 :item];
                }
                
            }
            
            for (NSArray *list in newCargories) {
                
                if ([list isKindOfClass:[NSArray class]]) {
                    CATEGORY *tmpObject = [[CATEGORY alloc] init];
                    tmpObject.id = objec.id;
                    tmpObject.name = objec.name;
                    tmpObject.goods = list;
                    
                    [allData addObject:tmpObject];
                }
            }
        }
        
        self.list.total += allData.count;
        
        
        for ( int i = 0; i < allData.count; i++ )
        {
            BeeUIScrollItem * categoryItem = self.list.items[ i + offset ];
            CATEGORY *object = [allData safeObjectAtIndex:i];
            if (object.goods.count == 1) {
                categoryItem.clazz = [B0_IndexCategoryCell_iPhoneOne class];
            }else if (object.goods.count == 2){
                categoryItem.clazz = [B0_IndexCategoryCell_iPhoneTwo class];
            }else if (object.goods.count == 3){
                categoryItem.clazz = [B0_IndexCategoryCell_iPhone class];
            }
            categoryItem.data = object;
            categoryItem.size = CGSizeMake( self.list.width, 180.0f );
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

- (void)dataYh:(NSArray *)tmp :(int )num :(id)item{
    
    [newCargories removeObjectAtIndex:num];
    
    if ([[tmp lastObject] intValue] == 1) {
        
        [onelist addObject:item];
        
        [newCargories insertObject:onelist atIndex:num];
        
    }else if ([[tmp lastObject] intValue] == 2) {
        
        [twolist addObject:item];
        
        [newCargories insertObject:twolist atIndex:num];
        
    }else if ([[tmp lastObject] intValue] == 3) {
        
        [threelist addObject:item];
        
        [newCargories insertObject:threelist atIndex:num];
    }
    
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
    
    D0_SearchInput_iPhone_new * searchBar = [[D0_SearchInput_iPhone_new alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];
    $(searchBar).FIND(@"#search-input").TEXT(@"贵州 礼品");
    
    for (UIView * vi in searchBar.subviews) {
        if([vi isKindOfClass:[UITextField class]]){
            ((UITextField *)vi).clearButtonMode = UITextFieldViewModeNever;
            ((UITextField *)vi).delegate = self;
            searchField = vi;
        }
        
    }
    
    
    self.titleView = searchBar;
}
ON_SIGNAL2( UIView, signal ){
    
    if(![signal.source isKindOfClass:[BeeUITextField class]]){
        [self.titleView endEditing:YES];
        
    }
    
}
- (void)doIntro:(NSString *)keyword
{
    
    if ( keyword.length )
    {
        B1_ProductListBoard_iPhone * board = [[[B1_ProductListBoard_iPhone alloc] init] autorelease];
        board.searchByHotModel.filter.intro = keyword;
        board.searchByCheapestModel.filter.intro = keyword;
        board.searchByExpensiveModel.filter.intro = keyword;
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
    D0_SearchInput_iPhone_new * searchBar= (D0_SearchInput_iPhone_new *)self.titleView;
    NSString *sea=$(searchBar).FIND(@"#search-input").text;
    if ([sea isEqualToString:@"贵州 礼品"]) {
        $(searchBar).FIND(@"#search-input").TEXT(@"");
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
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_CATEGORY] )
        {
            B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
            board.category = banner.description;
            board.searchByHotModel.filter.category_id = banner.action_id;
            board.searchByCheapestModel.filter.category_id = banner.action_id;
            board.searchByExpensiveModel.filter.category_id = banner.action_id;
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



ON_SIGNAL3( IndexCategoryTabCell, tea_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"生态好茶";
    board.searchByHotModel.filter.category_id =@(61);
    board.searchByCheapestModel.filter.category_id = @(61);
    board.searchByExpensiveModel.filter.category_id = @(61);
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, food_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"食品";
    board.searchByHotModel.filter.category_id =@(62);
    board.searchByCheapestModel.filter.category_id = @(62);
    board.searchByExpensiveModel.filter.category_id = @(62);
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, drink_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"酒";
    board.searchByHotModel.filter.category_id =@(63);
    board.searchByCheapestModel.filter.category_id = @(63);
    board.searchByExpensiveModel.filter.category_id = @(63);
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, health_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"保健品";
    board.searchByHotModel.filter.category_id =@(112);
    board.searchByCheapestModel.filter.category_id = @(112);
    board.searchByExpensiveModel.filter.category_id = @(112);
    [self.stack pushBoard:board animated:YES];
}
ON_SIGNAL3( IndexCategoryTabCell, art_button, signal )
{
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = @"工艺品";
    board.searchByHotModel.filter.category_id =@(136);
    board.searchByCheapestModel.filter.category_id = @(136);
    board.searchByExpensiveModel.filter.category_id = @(136);
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
     board.goodsModel.goods_id = goods.id;
     [self.stack pushBoard:board animated:YES];
     }*/
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
        }
        else if ( msg.failed )
        {
            [self showErrorTips:msg];
        }
    }
}

@end
