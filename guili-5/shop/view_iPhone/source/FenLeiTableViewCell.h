//
//  FenLeiTableViewCell.h
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^touchButton)(NSInteger num);
@interface FenLeiTableViewCell : UITableViewCell

+ (id)loadXib;

@property (nonatomic , strong)touchButton touch;

@end
