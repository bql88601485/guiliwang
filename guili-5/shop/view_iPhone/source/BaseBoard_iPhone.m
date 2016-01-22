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

#import "BaseBoard_iPhone.h"
#import "MobClick.h"

#pragma mark -

@implementation BaseBoard_iPhone

#pragma mark -

- (void)load
{
}

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = [UIImage imageNamed:@"index_body_bg.png"].patternColor;
}

ON_DELETE_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [MobClick beginLogPageView:[[self class] description]];
    
    
    [self setNav];
}
- (void)setNav{
    if (!self.isHome) {
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        // 配置导航条
        {
            [BeeUINavigationBar setTitleColor:[UIColor blackColor]];
            [BeeUINavigationBar setBackgroundColor:[UIColor whiteColor]];
            
            if ( IOS7_OR_LATER )
            {
                [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_iphone5Two.png"]];
            }
            else
            {
                [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]];
            }
            UILabel *line = (id )[self.navigationController.navigationBar viewWithTag:10010];
            if (line) {
                line.backgroundColor = [UIColor lightGrayColor];
            }
            else{
                line = [[UILabel alloc] init];
                line.frame = CGRectMake(0, self.navigationController.navigationBar.height - 1, self.navigationController.navigationBar.width, 1);
                line.tag = 10010;
                line.backgroundColor = [UIColor lightGrayColor];
                [self.navigationController.navigationBar addSubview:line];
            }
            
        }
    }else{
        
        
        // 配置导航条
        {
            [BeeUINavigationBar setTitleColor:[UIColor whiteColor]];
            [BeeUINavigationBar setBackgroundColor:[UIColor blackColor]];
            
            if ( IOS7_OR_LATER )
            {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
                
                [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_iphone5.png"]];
            }
            else
            {
                [BeeUINavigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]];
            }
            
            UILabel *line = (id )[self.navigationController.navigationBar viewWithTag:10010];
            if (line) {
                [line setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
}
ON_WILL_DISAPPEAR( signal )
{
    [MobClick endLogPageView:[[self class] description]];
}

@end
