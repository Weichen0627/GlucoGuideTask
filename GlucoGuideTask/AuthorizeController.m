//
//  AuthorizeController.m
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import "AuthorizeController.h"

#import "AuthorizeView.h"

#import "SizeView.h"

@interface AuthorizeController ()

@end

@implementation AuthorizeController

@synthesize authDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        //We use a special view that will tell us what the proper frame size is so we can
        //make sure the login view is centered in the modal view controller.
        self.view = [[SizeView alloc] initWithFrame:CGRectZero frameChangeDelegate:self];
    }
    return self;
}

-(void) dealloc
{
}

-(void) didAuthWithToken:(NSString*)token
{
    [self.authDelegate didAuthWithToken:token];
}

-(void) frameChanged:(CGRect)frame
{
    AuthorizeView *gha = [[AuthorizeView alloc] initWithFrame:frame];
    gha.authDelegate = self;
    [self.view addSubview:gha];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end

