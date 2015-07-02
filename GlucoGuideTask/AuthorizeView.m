//
//  AuthorizeView.m
//  GlucoGuideTask
//
//  Created by Weichen Liu on 15/7/1.
//  Copyright (c) 2015年 Weichen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Initializor.h"

#import "AuthorizeView.h"
#import "AuthorizeDelegate.h"
#import "UrlEncode.h"

@interface AuthorizeView()
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSURLConnection *tokenRequestConnection;
@end

@implementation AuthorizeView

@synthesize data;
@synthesize authDelegate;
@synthesize tokenRequestConnection;

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.delegate = self;
        self.authDelegate = nil;
        self.tokenRequestConnection = nil;
        self.data = [NSMutableData data];
        self.scalesPageToFit = YES;
        [self authorize];
    }
    
    return self;
}


-(void) dealloc
{
    [tokenRequestConnection cancel];
    self.delegate = nil;
}

-(void) authorize
{
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=http://localhost&response_type=code", CLIENT_ID];
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopLoading];
    
    if([error code] == -1009)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot open the page because it is not connected to the Internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *responseURL = [request.URL absoluteString];
    
    NSString *urlCallbackPrefix = [NSString stringWithFormat:@"%@/?code=", CALLBACK_BASE];
    
    //We received the code, now request the auth token from Instagram.
    if([responseURL hasPrefix:urlCallbackPrefix])
    {
        NSString *authToken = [responseURL substringFromIndex:[urlCallbackPrefix length]];
        
        NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"code", CALLBACK_BASE, @"redirect_uri", @"authorization_code", @"grant_type",  CLIENT_ID, @"client_id",  CLIENT_SECRET, @"client_secret", nil];
        
        NSString *paramString = [paramDict urlEncodedString];
        
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        [request setHTTPMethod:@"POST"];
        [request addValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.tokenRequestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [self.tokenRequestConnection start];
        
        return NO;
    }
    
    return YES;
    
}

#pragma Mark NSURLConnection delegates

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
    [self.data appendData:_data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.data setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&jsonError];
    if(jsonData && [NSJSONSerialization isValidJSONObject:jsonData])
    {
        NSString *accesstoken = [jsonData objectForKey:@"access_token"];
        if(accesstoken)
        {
            [self.authDelegate didAuthWithToken:accesstoken];
            return;
        }
    }
    
    [self.authDelegate didAuthWithToken:nil];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

@end
