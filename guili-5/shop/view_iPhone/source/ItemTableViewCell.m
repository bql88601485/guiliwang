//
//  ItemTableViewCell.m
//  shop
//
//  Created by bai on 16/1/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell

+ (id)loadXib:(NSInteger )num{
    NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ItemTableViewCell" owner:nil options:nil];
    return [nibObjects objectAtIndex:num];
}

- (void)awakeFromNib {
    // Initialization code
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    self.width = size.width;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)set3Data:(id)data{
    
    self.allData = data;
    
    SIMPLE_GOODS *object = [self.allData objectAtIndex:0];
    
    [self._3_Img_0 setUrl:object.img.url];
    self._3_title_0.text = object.name;
    self._3_price_0.text = object.shop_price;
    
    
    object = [self.allData objectAtIndex:1];
    
    [self._3_Img_1 setUrl:object.img.url];
    self._3_title_1.text = object.name;
    self._3_price_1.text = object.shop_price;
    
    object = [self.allData objectAtIndex:2];
    
    [self._3_Img_2 setUrl:object.img.url];
    self._3_title_2.text = object.name;
    self._3_price_2.text = object.shop_price;
}

- (void)set2Data:(id)data{
    
    self.allData = data;
    
    SIMPLE_GOODS *object = [self.allData firstObject];
    
    [self._2_Img_0 setUrl:object.img.url];
    
    self._2_title_0.text = object.name;
    self._2_price_0.text = object.shop_price;
    
    object = [self.allData lastObject];
    
    [self._2_Img_1 setUrl:object.img.url];
    
    self._2_title_1.text = object.name;
    self._2_price_1.text = object.shop_price;
}

- (void)set1Data:(id)data{
    
    self.allData = data;
    
    SIMPLE_GOODS *object = [self.allData firstObject];
    
    if (object.teshuGG) {
        [self.ggImage setHidden:NO];
        [self.ggImage setUrl:object.img.url];
        self._1_price.text = @"";
    }else{
        [self.ggImage setHidden:YES];
        [self._1_Img_0 setUrl:object.img.url];
        
        self._1_title.text = object.name;
        self._1_price.text = object.shop_price;
    }
}

- (IBAction)touchMYItem:(UIButton *)sender{
    
    self.touchData = [self.allData objectAtIndex:sender.tag-1];
    
    if (self.kTouch) {
        self.kTouch(self.touchData);
    }
}

- (void)dealloc {
    [__3_Img_0 release];
    [__3_Img_1 release];
    [__3_Img_2 release];
    [__2_Img_0 release];
    [__2_Img_1 release];
    [__1_Img_0 release];
    [__1_price release];
    [__1_title release];
    [super dealloc];
}
@end
