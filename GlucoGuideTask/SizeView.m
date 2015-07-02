//
//  SizeView.m
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import "SizeView.h"

@interface SizeView()
@property(nonatomic, weak) id<FrameChangeDelegate> delegate;
@end

@implementation SizeView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame frameChangeDelegate:(id<FrameChangeDelegate>)_delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = _delegate;
    }
    return self;
}

-(void) layoutSubviews
{
    [self.delegate frameChanged:self.frame];
}

@end
