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

#import "B0_BannerCell_iPhone.h"
#import "B0_BannerPhotoCell_iPhone.h"

#pragma mark -

@interface B0_BannerCell_iPhone()
@property (nonatomic, assign) CGFloat count;
@end

@implementation B0_BannerCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( BeeUIPageControl, pager )

- (void)load
{
    /**
     * BeeFramework中scrollView使用方式由0.4.0改为0.5.0
     * 将board中BeeUIScrollView对应的signal转换为block的实现方式
     * BeeUIScrollView的block方式写法可以从它对应的delegate方法中转换而来
     */
    self.count = 0;
    @weakify(self);
    
    self.list.animationDuration = 0.25f;
    
    self.list.whenReloading = ^
    {
        @normalize(self);
        
        NSArray * datas = (NSArray *)self.data;
        
        self.list.total = datas.count;
        self.pager.hidesForSinglePage = YES;
        
        for ( BeeUIScrollItem * item in self.list.items )
        {
            item.clazz = [B0_BannerPhotoCell_iPhone class];
            item.size = self.list.size;
            item.data = [datas safeObjectAtIndex:item.index];
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
        
        if (self.list.items.count > 0) {
            if (!self.pollTime) {
                self.pollTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(play) userInfo:nil repeats:YES];
            }
        }
    };
    self.list.whenReloaded = ^
    {
        @normalize(self);
        
        self.pager.numberOfPages = self.list.total;
        self.pager.currentPage = self.list.pageIndex;
        
        [self.pager setNeedsDisplay];
    };
    self.list.whenStop = ^
    {
        @normalize(self);;
        
        self.pager.numberOfPages = self.list.total;
        self.pager.currentPage = self.list.pageIndex;
        self.count = self.list.pageIndex;
        [self.pager setNeedsDisplay];
    };
}
- (void)play{
    if (self.width > 0) {
        
        [self.pager setCurrentPage:self.count];
        
        [self.list setContentOffset:CGPointMake(self.width*self.count, 0) animated:YES];
        
        self.count++;
        
        if (self.count > self.list.items.count -1) {
            self.count = 0;
        }
    }
    
}
- (void)dataDidChanged
{
    [self.list reloadData];
}

@end
