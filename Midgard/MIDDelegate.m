//
//  Midgard.m
//  Midgard
//
//  Created by Marcos Garcia on 8/14/12.
//  Copyright (c) 2012 Coderockr. All rights reserved.
//

#import "MIDDelegate.h"

@implementation MIDDelegate

@synthesize cache = _cache;
@synthesize webView = _webView;
@synthesize data = _data;
@synthesize request = _request;

#pragma mark - Getters
- (NSFileManager *) cache
{
    if (_cache == nil) {
        _cache = [[NSFileManager alloc] init];
        _cache.delegate = self;
    }
    return _cache;
}

- (UIWebView *) webView
{
    return _webView;
}

- (NSURLRequest *) request
{
    return _request;
}

- (NSMutableData *) data
{
    if (_data == nil) {
        _data = [[NSMutableData alloc] init];
    }
    return _data;
}

#pragma mark - File URL generator
- (NSURL *) URLToSaveFileFromRequest:(NSURLRequest *)request
{
    NSURL *fileURL = [[NSURL alloc] initWithScheme:@"file" host:@"localhost" path:request.URL.path];
    return fileURL;
}

#pragma mark - UIWebViewDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqual:@"file"]) {
        NSLog(@"load from cache");
        return YES;
    }
    
    NSURL *cacheURL = [self URLToSaveFileFromRequest:request];
    NSData *cacheData = [NSData dataWithContentsOfURL:cacheURL];
    
    if (cacheData.length > 0) {
        [self.webView loadData:cacheData
                      MIMEType:@"text/html"
              textEncodingName:@"utf-8"
                       baseURL:cacheURL];
        return NO;
    }
    
    self.webView = webView;
    self.request = request;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    return NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished load");
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) return;
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    NSLog(@"Fail load with error: %@", error);
}

#pragma mark - NSURLConnectionDelegate
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURL *cacheURL = [self URLToSaveFileFromRequest:self.request];
    [self.data writeToURL:cacheURL atomically:YES];
    
    [self.webView loadData:self.data
                  MIMEType:@"text/html"
          textEncodingName:@"utf-8"
                   baseURL:cacheURL];
}

@end
