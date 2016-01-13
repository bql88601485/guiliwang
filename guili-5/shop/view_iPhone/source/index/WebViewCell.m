//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  WebViewCell.m
//  shop
//
//  Created by luppy01 on 15-3-15.
//  Copyright (c) 2015年 geek-zoo studio. All rights reserved.
//

#import "WebViewCell.h"

#pragma mark -

@implementation WebViewCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )
DEF_OUTLET( BeeUIWebView, webView )
- (void)load
{
}

- (void)unload
{
}

- (void)dataDidChanged
{
    // TODO: fill data
   
    
    if ( self.data )
    {
        self.webView.html= self.data;
    }
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
