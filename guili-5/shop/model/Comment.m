//
//  Comment.m
//  shop
//
//  Created by baiqilong on 16/1/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "Comment.h"

@implementation Comment
DEF_SINGLETON( Comment )

@synthesize goods_id = _goods_id;
@synthesize email = _email;
@synthesize user_name = _user_name;
@synthesize user_id = _user_id;
@synthesize content = _content;

- (void)sendComment:(NSString *)goods_id
            comment:(NSString *)content{
    
    USER *user = [USER readFromUserDefaults:@"UserModel.user"];
    
    
    self.CANCEL_MSG( API.user_signin );
    self
    .MSG( API.user_signin )
    .INPUT( @"name", user )
    .INPUT( @"password", password );
}

@end
