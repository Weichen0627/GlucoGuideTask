//
//  AuthorizeController.h
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AuthorizeDelegate.h"

@protocol FrameChangeDelegate
-(void) frameChanged:(CGRect)frame;
@end

@interface AuthorizeController : UIViewController <FrameChangeDelegate, AuthorizeDelegate>
@property(nonatomic, weak) id<AuthorizeDelegate> authDelegate;

@end
