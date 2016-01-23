//
//  ItemTableViewCell.h
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Tcouhhh)(SIMPLE_GOODS *touchData);
@interface ItemTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray * allData;

@property (nonatomic, strong) SIMPLE_GOODS *touchData;

+ (id)loadXib:(NSInteger )num;

- (void)set3Data:(id)data;

- (void)set2Data:(id)data;

- (void)set1Data:(id)data;


@property (nonatomic, strong) Tcouhhh kTouch;

//3

@property (retain, nonatomic) IBOutlet BeeUIImageView *_3_Img_0;
@property (retain, nonatomic) IBOutlet BeeUIImageView *_3_Img_1;
@property (retain, nonatomic) IBOutlet BeeUIImageView *_3_Img_2;

@property (retain, nonatomic) IBOutlet UILabel *_3_price_0;
@property (retain, nonatomic) IBOutlet UILabel *_3_title_0;

@property (retain, nonatomic) IBOutlet UILabel *_3_price_1;
@property (retain, nonatomic) IBOutlet UILabel *_3_title_1;

@property (retain, nonatomic) IBOutlet UILabel *_3_price_2;
@property (retain, nonatomic) IBOutlet UILabel *_3_title_2;

//2
@property (retain, nonatomic) IBOutlet BeeUIImageView *_2_Img_0;
@property (retain, nonatomic) IBOutlet BeeUIImageView *_2_Img_1;


@property (retain, nonatomic) IBOutlet UILabel *_2_price_0;
@property (retain, nonatomic) IBOutlet UILabel *_2_title_0;

@property (retain, nonatomic) IBOutlet UILabel *_2_price_1;
@property (retain, nonatomic) IBOutlet UILabel *_2_title_1;

//1
@property (retain, nonatomic) IBOutlet BeeUIImageView *_1_Img_0;

@property (retain, nonatomic) IBOutlet UILabel *_1_price;
@property (retain, nonatomic) IBOutlet UILabel *_1_title;

@property (nonatomic, retain) IBOutlet BeeUIImageView *ggImage;


@end
