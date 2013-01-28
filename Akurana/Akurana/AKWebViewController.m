//
//  AKWebViewController.h
//  Akurana
//

/*
 
 Copyright (c) 2012, Shafraz Buhary
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the Copyright holder  nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "AKWebViewController.h"
#import "AKTheme.h"
#import "UIView+Akurana.h"
#import "UIToolbar+Akurana.h"

@interface AKWebViewController()

@property(nonatomic, strong, readwrite) NSURL* url;

@end

@implementation AKWebViewController

- (void)backAction {
    [webView_ goBack];
}

- (void)forwardAction {
    [webView_ goForward];
}

- (void)refreshAction {
    [webView_ reload];
}

- (void)stopAction {
    [webView_ stopLoading];
}

- (void)shareAction {
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Open in Safari", @""), nil];
    [sheet showInView:self.view];
}


- (id)init {
    if (self = [super init]) {
        //_delegate = nil;
        webView_ = nil;
        toolbar_ = nil;
        self.headerView = nil;
        backButton_ = nil;
        forwardButton_ = nil;
        stopButton_ = nil;
        refreshButton_ = nil;
    }
    return self;
}


- (void)loadView {  
    [super loadView];
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width - 88)];
    webView_.delegate = self;
    
    webView_.scalesPageToFit = YES;
    [self.view addSubview:webView_];
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    activityItem_ = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    backButton_ = [[UIBarButtonItem alloc] initWithImage:[AKTheme getImage:@"backIcon.png"]
                                                   style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButton_.tag = 2;
    backButton_.enabled = NO;
    forwardButton_ = [[UIBarButtonItem alloc] initWithImage:[AKTheme getImage:@"forwardIcon.png"]
                                                      style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction)];
    forwardButton_.tag = 1;
    forwardButton_.enabled = NO;
    refreshButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                      UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    refreshButton_.tag = 3;
    stopButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                   UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
    stopButton_.tag = 3;
    UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    
    UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                         UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar_ = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.height, 44)];
    toolbar_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    toolbar_.tintColor = self.navigationController.navigationBar.tintColor; 

    toolbar_.items = @[space,backButton_, forwardButton_, refreshButton_, actionButton, space];
    [self.view addSubview:toolbar_];
}


- (void)unloadView {
    webView_ = nil;
    toolbar_ = nil;
    backButton_ = nil;
    forwardButton_ = nil;
    refreshButton_ = nil;
    stopButton_ = nil;
    activityItem_ = nil;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
    self.title = NSLocalizedString(@"Loading...", @"");
    self.navigationItem.rightBarButtonItem = activityItem_;
    [toolbar_ replaceItemWithTag:3 withItem:stopButton_];
    backButton_.enabled = [webView_ canGoBack];
    forwardButton_.enabled = [webView_ canGoForward];
}


- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.title = [webView_ stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.rightBarButtonItem = nil;
    [toolbar_ replaceItemWithTag:3 withItem:refreshButton_];
    [webView_ canGoBack];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [self webViewDidFinishLoad:webView];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:webView_.request.URL];
    }
}


- (NSURL*)url {
    return webView_.request.URL;
}

- (void)openRequest:(NSURLRequest*)request {
    [self view];
    [webView_ loadRequest:request];
}

- (void)setHeaderView:(UIView*)headerView {
    
    if (headerView != _headerView) {
        BOOL addingHeader = !_headerView && headerView;
        BOOL removingHeader = _headerView && !headerView;
        
        [_headerView removeFromSuperview];
        _headerView = headerView;
        _headerView.frame = CGRectMake(0, 0, webView_.frame.size.width, _headerView.frame.size.height);
        
        [self view];
        UIView* scroller = [webView_ firstViewOfClass:NSClassFromString(@"UIScroller")];
        UIView* docView = [scroller firstViewOfClass:NSClassFromString(@"UIWebDocumentView")];
        [scroller addSubview:_headerView];
        
        if (addingHeader) {
            docView.top += headerView.height;
            docView.height -= headerView.height; 
        } else if (removingHeader) {
            docView.top -= headerView.height;
            docView.height += headerView.height; 
        }
    }
}

- (void)openURL:(NSURL*)url {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [self openRequest:request];
}

@end
