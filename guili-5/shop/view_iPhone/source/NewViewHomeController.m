//
//  NewViewHomeController.m
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "NewViewHomeController.h"
#import "CommonPullLoader.h"

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

#import "A0_SigninBoard_iPhone.h"

#import "FenLeiTableViewCell.h"
#import "TwoTableViewCell.h"
#import "ItemTableViewCell.h"
@interface NewViewHomeController ()<UISearchBarDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray *newCargories;
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * _line;
}

@property (retain, nonatomic) BeeUIScrollView *homelist;
@property (retain, nonatomic) TwoTableViewCell *searchIn;

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation NewViewHomeController

DEF_INT( ACTION_ADD,    1)
DEF_INT( ACTION_BUY,    2)
DEF_INT( ACTION_SPEC,   3)

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_MODEL( BannerModel,		bannerModel );
DEF_MODEL( CategoryModel,	categoryModel );


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
- (void)wuliuxinxi{
    WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.stack pushBoard:web animated:YES];
}
#pragma mark -
- (void)loging{
    
    if ([self.stack.topViewController isKindOfClass:[A0_SigninBoard_iPhone class]]) {
        return;
    }
    A0_SigninBoard_iPhone   *singin = [[[A0_SigninBoard_iPhone alloc] initWithNibName:@"A0_SigninBoard_iPhone" bundle:nil] autorelease];
    
    [self.stack.topViewController presentViewController:singin animated:NO completion:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (bee.ui.tabbar.selectNUm == 0) {
        self.isHome = YES;
        
        [bee.ui.appBoard showTabbar];
        
        //        [self.search_input resignFirstResponder];
    }
}
- (void)newTouch:(SIMPLE_GOODS *)goods{
    
    if ( goods )
    {
        if (goods.teshuGG) {
            
            NSString *newUrl = [[goods.seller_note componentsSeparatedByString:@"|"] objectAtIndex:2];
            
            B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
            board.category = @"发现";
            board.isfromHome = YES;
            board.isfromBanner = YES;
            board.kids = newUrl;
            [self.stack pushBoard:board animated:YES];
        }else{
            B2_ProductDetailBoard_iPhone * board = [B2_ProductDetailBoard_iPhone board];
            board.goodsModel.goods_id = goods.id;
            [self.stack pushBoard:board animated:YES];
        }
    }
}

- (void)ComenInItme:(NSInteger )num1{
    
    NSString *totle = @"";
    NSString *idd = @"";
    switch (num1) {
        case 1:
            totle = @"酒类直供";
            idd = @"137";
            break;
        case 2:
            totle = @"有机茶叶";
            idd = @"138";
            break;
        case 3:
            totle = @"原生食品";
            idd = @"139";
            break;
        case 4:
            totle = @"特色调料";
            idd = @"140";
            break;
        case 5:
            totle = @"养生保健";
            idd = @"141";
            break;
        case 6:
            totle = @"艺术收藏";
            idd = @"122";
            break;
        default:
            break;
    }
    
    B1_ProductListBoard_iPhone * board = [B1_ProductListBoard_iPhone board];
    board.category = totle;
    board.kid = [NSNumber numberWithFloat:[idd floatValue]];
    board.isfromHome = YES;
    [self.stack pushBoard:board animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        D0_SearchInput_iPhone_new * searchBar = [[D0_SearchInput_iPhone_new alloc] initWithFrame:CGRectMake(0, 0., self.view.width, 44.0f)];
        
        self.titleView = searchBar;
    });
    
    self.navigationBarShown = YES;
    [self showNavigationBarAnimated:NO];
    //self.navigationBarTitle = __TEXT(@"ecmobile");
    
    /**
     * BeeFramework中scrollView使用方式由0.4.0改为0.5.0
     * 将board中BeeUIScrollView对应的signal转换为block的实现方式
     * BeeUIScrollView的block方式写法可以从它对应的delegate方法中转换而来
     */
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loging) name:@"dengluqu" object:nil];
    
    self.isHome = YES;
    
    
    CGRect size = [[UIScreen mainScreen] bounds];
    
    self.searchIn = [TwoTableViewCell loadXib:2];
    self.searchIn.delegate = self;
    [self.searchIn setWidth:size.size.width];
    [self.searchIn setTop:0];
    [self.view addSubview:self.searchIn];
    
    self.searchIn.searInput.delegate = self;
    
    self.homelist = [[BeeUIScrollView alloc] initWithFrame:size];
    [self.homelist setBackgroundColor:[UIColor colorWithString:@"#f2f2f2"]];
    [self.view addSubview:self.homelist];
    
    [self.homelist setTop:0];
    
    @weakify(self);
    
    self.homelist.headerClass = [CommonPullLoader class];
    self.homelist.headerShown = YES;
    
    self.homelist.lineCount = 1;
    self.homelist.animationDuration = 0.25f;
    
    
    self.homelist.whenReloading = ^
    {
        @normalize(self);
        
        for (UIView *view in self.homelist.subviews) {
            if ([view isKindOfClass:[CommonPullLoader class]]) {
                continue;
            }else{
                [view removeFromSuperview];
            }
        }
        
        self.homelist.total = self.bannerModel.banners.count ? 1 : 0;
        self.homelist.total += self.bannerModel.goods.count ? 1 : 0;
        self.homelist.total+=1;//分类
        self.homelist.total+=1;//积分商城
        
        
        int offset = 0;
        
        if ( self.bannerModel.banners.count )
        {
            BeeUIScrollItem * banner = self.homelist.items[offset];
            banner.clazz = [B0_BannerCell_iPhone class];
            banner.data = self.bannerModel.banners;
            banner.size = CGSizeMake( self.homelist.width, 150.0f);
            banner.rule = BeeUIScrollLayoutRule_Line;
            banner.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        FenLeiTableViewCell *fenlei = [FenLeiTableViewCell loadXib];
        fenlei.frame = CGRectMake(0, 145, self.homelist.width, 165);
        [self.homelist addSubview:fenlei];
        fenlei.touch = ^(NSInteger num1){
            
            [self ComenInItme:num1];
            
        };
        
        
        TwoTableViewCell *next1 = [TwoTableViewCell loadXib:0];
        next1.frame = CGRectMake(0, fenlei.bottom, self.homelist.width, 39);
        [self.homelist addSubview:next1];
        
        [next1.toucbuButton addTarget:self action:@selector(wuliuxinxi) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGFloat starY = next1.bottom;
        //分类
        NSMutableArray *allData = [[NSMutableArray alloc] init];
        
        for (CATEGORY *objec in self.categoryModel.categories) {
            
            newCargories = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3", nil];
            
            
            for (SIMPLE_GOODS *item in objec.goods) {
                
                NSString *seller_note = item.seller_note;
                
                if (seller_note.length <= 0 ) {
                    continue;
                }
                NSArray *tmp = [seller_note componentsSeparatedByString:@"|"];
                
                if (tmp.count > 2) {
                    item.teshuGG = YES;
                }
                
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
        
        self.homelist.total += allData.count;
        
        
        for ( int i = 0; i < allData.count; i++ )
        {
            CATEGORY *object = [allData safeObjectAtIndex:i];
            if (object.goods.count == 1) {
                if (object.change > 0) {
                    
                    starY += 7;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:2];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set1Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                    
                }else{
                    
                    TwoTableViewCell *next1 = [TwoTableViewCell loadXib:1];
                    next1.frame = CGRectMake(0, starY, self.homelist.width, 25);
                    [self.homelist addSubview:next1];
                    
                    next1.titleName.text = object.name;
                    
                    starY = next1.bottom;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:2];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set1Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                }
            }else if (object.goods.count == 2){
                if (object.change > 0) {
                    
                    starY += 7;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:1];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set2Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                    
                }else{
                    
                    TwoTableViewCell *next1 = [TwoTableViewCell loadXib:1];
                    next1.frame = CGRectMake(0, starY, self.homelist.width, 25);
                    [self.homelist addSubview:next1];
                    
                    next1.titleName.text = object.name;
                    
                    starY = next1.bottom;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:1];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set2Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                    
                }
            }else if (object.goods.count == 3){
                if (object.change > 0) {
                    
                    starY += 7;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:0];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set3Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                    
                }else{
                    
                    TwoTableViewCell *next1 = [TwoTableViewCell loadXib:1];
                    next1.frame = CGRectMake(0, starY, self.homelist.width, 25);
                    [self.homelist addSubview:next1];
                    
                    next1.titleName.text = object.name;
                    
                    starY = next1.bottom;
                    
                    ItemTableViewCell *item = [ItemTableViewCell loadXib:0];
                    [item setTop:starY];
                    [self.homelist addSubview:item];
                    
                    [item set3Data:object.goods];
                    
                    starY = (item.bottom);
                    
                    item.kTouch = ^(SIMPLE_GOODS *object ){
                        
                        [self newTouch:object];
                    };
                }
            }
        }
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.homelist setContentSize:CGSizeMake(0, starY + 120)];
        });
        
    };
    self.homelist.whenHeaderRefresh = ^
    {
        
        @normalize(self);
        
        [self.bannerModel reload];
        [self.categoryModel reload];
        
        [[CartModel sharedInstance] reload];
    };
    
    
    
    
}
ON_DID_APPEAR( signal )
{
    if ( NO == self.bannerModel.loaded )
    {
        [self.bannerModel reload];
    }
    
    if ( NO == self.categoryModel.loaded )
    {
        [self.categoryModel reload];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dataYh:(NSArray *)tmp :(NSUInteger )num1 :(id)item{
    
    NSMutableArray *tmepArray = [newCargories objectAtIndex:num1];
    if ([tmepArray isKindOfClass:[NSMutableArray class]]) {
    }else{
        tmepArray = [[NSMutableArray alloc] init];
    }
    
    [newCargories removeObjectAtIndex:num1];
    
    [tmepArray addObject:item];
    
    [newCargories insertObject:tmepArray atIndex:num1];
}




- (void)dealloc {
    [_homelist release];
    [super dealloc];
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
        [self.homelist setHeaderLoading:NO];
        
        [self dismissTips];
        
        if ( msg.succeed )
        {
            [self.homelist asyncReloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.homelist asyncReloadData];
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
        [self.homelist setHeaderLoading:NO];
        
        [self dismissTips];
        
        if ( msg.succeed )
        {
            [self.homelist asyncReloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.homelist asyncReloadData];
            });
        }
        else if ( msg.failed )
        {
            [self showErrorTips:msg];
        }
    }
}

ON_SIGNAL3( D0_SearchInput_iPhone_new, sear_button, signal ){
    
    [self.searchIn.searInput resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        if ( self.homelist.top == self.searchIn.bottom) {
            [self.homelist setTop:0];
        }else{
            [self.homelist setTop:self.searchIn.bottom];;
        }
    }];
}
ON_SIGNAL3( D0_SearchInput_iPhone_new, home_button, signal ){
    
    if ( NO == [UserModel online] )
    {
        [bee.ui.appBoard showLogin];
        return;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
            
            if (buttonIndex == 0) {
                [self ShowZbar:sourceType];
                return;
            }
            
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        [self showBendi];
        
    }
}


- (void)cancelText{
    
}
- (void)showBendi{
    
    ZBarReaderController *reader = [ZBarReaderController new];
    
    reader.allowsEditing = NO   ;
    
    reader.showsHelpOnFail = NO;
    
    reader.readerDelegate = self;
    
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:reader animated:YES completion:nil];
    
}
- (void)ShowZbar:(NSUInteger)sourceType{
    
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    reader.sourceType = sourceType;
    //        reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    //        [reader.view setFrame:CGRectMake(0, 20 + 44, self.view.bounds.size.width, self.view.frame.size.height)];
    
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        reader.showsHelpOnFail = NO;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        view.backgroundColor = [UIColor clearColor];
        reader.cameraOverlayView = view;
        
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
    }
    
    NSLog(@"navig =%@",self.navigationController);
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
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
    
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
    if ( NO == [UserModel online] )
    {
        [bee.ui.appBoard showLogin];
        return;
    }
}


//搜索
- (void)doSearch:(NSString *)keyword
{
    [self.searchIn.searInput resignFirstResponder];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
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


@end
