//
//  TwoTableViewCell.m
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "TwoTableViewCell.h"

@implementation TwoTableViewCell
+ (id)loadXib:(NSInteger )num{
    NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TwoTableViewCell" owner:nil options:nil];
    return [nibObjects objectAtIndex:num];
}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleName release];
    [_searInput release];
    [super dealloc];
}



@end
