//
//  AuthorizeDelegate.h
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthorizeDelegate <NSObject>

-(void) didAuthWithToken:(NSString*)token;

@end