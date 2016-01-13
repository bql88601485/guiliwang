//
//  AreaObject.h
//  Wujiang
//
//  Created by zhengzeqin on 15/5/28.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//
//区域对象
#import <Foundation/Foundation.h>

@interface AreaObject : NSObject

//区域
@property (copy, nonatomic) NSString *region;
@property (nonatomic, retain) NSNumber *regionID;
//省名
@property (copy, nonatomic) NSString *province;
@property (nonatomic, retain) NSNumber *provinceID;
//城市名
@property (copy, nonatomic) NSString *city;
@property (nonatomic, retain) NSNumber *cityID;
//区县名
@property (copy, nonatomic) NSString *area;
@property (nonatomic, retain) NSNumber *areaID;

@end
