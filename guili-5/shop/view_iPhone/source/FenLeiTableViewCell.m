//
//  FenLeiTableViewCell.m
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "FenLeiTableViewCell.h"

@implementation FenLeiTableViewCell
+ (id)loadXib{
    NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FenLeiTableViewCell" owner:nil options:nil];
    return [nibObjects firstObject];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)touchButt:(UIButton *)sender{
    
    if (self.touch) {
        self.touch(sender.tag);
    }
    
}

@end
