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

#import "OrderCellBody_iPhone.h"
#import "G0_CommentVController.h"
#import "E4_HistoryBoard_iPhone.h"
#pragma mark -

@implementation OrderCellBody_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    
}

- (void)unload
{
}

- (void)dataDidChanged
{
    _goods = nil;
    if ([self.data isKindOfClass:[NSDictionary class]]) {
        _goods = [self.data objectForKey:@"data"];
        self.kisBeeVc = [self.data objectForKey:@"bee"];
    }
    else{
        _goods = self.data;;
    }
    
    if (_goods.isFromHistory) {
        $(@"#order-button").SHOW();
        $(@"#order-button").SHOW();
    }else{
        $(@"#order-button").HIDE();
    }
    
    $(@"#order-goods-count").TEXT( [NSString stringWithFormat:@"X %@", _goods.goods_number] );
    $(@"#order-goods-price").TEXT( _goods.formated_shop_price );
    $(@"#order-goods-title").TEXT( _goods.name );
    $(@"#order-goods-photo").IMAGE( _goods.img.thumbURL );
    
}
ON_SIGNAL3(OrderCellBody_iPhone, order_button, signal){
    G0_CommentVController *comment = [[G0_CommentVController alloc] initWithNibName:@"G0_CommentVController" bundle:nil];
    comment.Kgoods = self.goods;
    [((E4_HistoryBoard_iPhone *)self.kisBeeVc).stack pushBoard:comment animated:YES];
}
@end
