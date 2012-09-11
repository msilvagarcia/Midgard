//
//  Midgard.h
//  Midgard
//
//  Created by Marcos Garcia on 8/14/12.
//  Copyright (c) 2012 Coderockr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIWebView.h>

@interface MIDDelegate : NSObject <UIWebViewDelegate, NSURLConnectionDelegate, NSFileManagerDelegate>

@property (strong, nonatomic) NSFileManager *cache;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSMutableData *data;

@end
