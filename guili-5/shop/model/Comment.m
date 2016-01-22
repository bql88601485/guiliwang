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
    self.email = user.email;
    self.user_id = [user.id stringValue];
    self.user_name = user.name;
    
    self.goods_id = goods_id;
    self.content = content;
    
    self.CANCEL_MSG( API.SENDCOMMENT );
    self
    .MSG( API.SENDCOMMENT )
    .INPUT( @"goods_id", self.goods_id )
    .INPUT( @"email", self.email )
    .INPUT( @"user_name", self.user_name )
    .INPUT( @"content", self.content )
    .INPUT( @"user_id", self.user_id );
}

@end
