//
//  ViewController.m
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import "ViewController.h"
#import "Initializor.h"
#import "AuthorizeController.h"
#import "ShowViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{

    [self performSelector:@selector(checkInstagramAuth) withObject:nil afterDelay:2];
    [super viewDidLoad];
}


//This is our authentication delegate. When the user logs in, and
// Instagram sends us our auth token, we receive that here.
-(void) didAuthWithToken:(NSString*)token
{

    if(!token)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Failed to request token."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //Search for media within 2 days.
    
    NSDate *passedDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*(-2)];
    NSString* timestamp = [NSString stringWithFormat:@"%f",[passedDays timeIntervalSince1970]];
    NSString *recentURLString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?min_timestamp=%@&access_token=%@",timestamp,token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:recentURLString]];
    
    
    NSOperationQueue *theQ = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:theQ
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSError *err;
                               id val = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                               
                               if(!err && !error && val && [NSJSONSerialization isValidJSONObject:val])
                               {
                                   NSArray *data = [val objectForKey:@"data"];
                                   
                                   int size = [data count];
                                   NSString *message = [NSString stringWithFormat: @"There are %i objects in the array", size];
                                
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Passed"
                                                                                       message:message
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   
                                }
                           }];
}

-(void) checkInstagramAuth
{
    AuthorizeController *authorizeController = [AuthorizeController new];
    authorizeController.authDelegate = self;
    
    authorizeController.modalPresentationStyle = UIModalPresentationFormSheet;
    authorizeController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:authorizeController animated:YES completion:^{ } ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
