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

#import "B5_ProductCommentCell_iPhone.h"

#pragma mark -

@implementation B5_ProductCommentCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, background )
DEF_OUTLET( BeeUILabel, creator )
DEF_OUTLET( BeeUILabel, date )
DEF_OUTLET( BeeUILabel, content );
DEF_OUTLET( BeeUILabel, Kongbai );
- (void)dataDidChanged
{
    COMMENT * comment = self.data;
    
    if ( comment )
    {
        self.creator.text = [NSString stringWithFormat:@"%@", comment.author];
        self.content.text = comment.content;
        self.date.text = [[comment.create asNSDate] stringWithDateFormat:@"YYYY-MM-DD HH:MM:SS"];
        self.Kongbai.text = nil;
        
        switch ( comment.scrollIndex )
        {
            case UIScrollViewIndexFirst:
                self.Kongbai.text = @"     ";
                self.background.data = @"cell_bg_headerNew.png";
                break;
            case UIScrollViewIndexLast:
                self.background.data = @"cell_bg_content.png";
                break;
            case UIScrollViewIndexSingle:
                self.background.data = @"cell_bg_content.png";
                break;
            case UIScrollViewIndexDefault:
                self.background.data = @"cell_bg_content.png";
                break;
        }
    }
}

@end
