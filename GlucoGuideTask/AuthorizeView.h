//
//  AuthorizeView.h
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthorizeController.h"

@interface AuthorizeView : UIWebView <UIWebViewDelegate>

@property(nonatomic, weak) id<AuthorizeDelegate> authDelegate;

@end

