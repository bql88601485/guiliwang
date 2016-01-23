//
//  TwoTableViewCell.h
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoTableViewCell : UITableViewCell

+ (id)loadXib:(NSInteger )num;


@property (nonatomic ,assign)id delegate;

/**
 *  @author bai, 16-01-23 18:01:55
 *
 *  @brief title
 */

@property (retain, nonatomic) IBOutlet UILabel *titleName;




@property (retain, nonatomic) IBOutlet UISearchBar *searInput;


@property (retain, nonatomic) IBOutlet UIButton *toucbuButton;

@end
