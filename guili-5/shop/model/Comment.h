//
//  Comment.h
//  shop
//
//  Created by baiqilong on 16/1/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "Bee_OnceViewModel.h"

@interface Comment : BeeOnceViewModel

AS_SINGLETON( Comment )

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *user_id;

- (void)sendComment:(NSString *)goods_id
            comment:(NSString *)content;


@end
