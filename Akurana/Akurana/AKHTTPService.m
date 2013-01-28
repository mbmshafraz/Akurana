//
//  AKHTTPService.m
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

#import "AKHTTPService.h"
#import "SBJSON.h"
#import "AKRSSFeed.h"
#import "NSObject+Akurana.h"

#define DEFAULT_TIMEOUT 60
#define DEFAULT_CACHEPOLICY NSURLRequestReloadIgnoringLocalCacheData

@implementation AKHTTPService

- (void)cancelRequest
{
    if (connection_) {
        [connection_ cancel];
        connection_ = nil;
    }
}

+ (NSString *)stringWithData:(NSData *)data
{     
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)objectWithData:(NSData *)data
{
    NSString *jsonString = [AKHTTPService stringWithData:data];
    SBJSON *jsonParser = [SBJSON new];
    return [jsonParser objectWithString:jsonString error:NULL];
}

+ (NSString *)jsonWithObject:(id)value
{
    SBJSON *jsonParser = [SBJSON new];
    
    return [jsonParser stringWithFragment:value error:NULL];
}

- (id)init
{
    if (self=[super init]) {
        onSuccessCallback_ = nil;
        onFailCallback_ = nil;
    }
    return self;
}

- (void)dealloc
{
    [self cancelRequest];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.responseCode = [httpResponse statusCode];
    self.responseData = [NSMutableData new];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
    connection_ = nil;
    
    NSLog(@"%@",error);
    
    if (onFailCallback_) {
        [target_ performSelector:onFailCallback_ withObject:@{AKHTTPServiceError:error,AKHTTPServiceUserInfor:userInfo_} afterDelay:0];
    } else {
        [delegate_ service:self didFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    if (onSuccessCallback_) {
        [target_ performSelector:onSuccessCallback_ withObject:@{AKHHTPServiceData:self.responseData,AKHTTPServiceUserInfor:userInfo_} afterDelay:0];
    } else if (jsonOnSuccessCallback_) {
        id dataObject = [AKHTTPService objectWithData:_responseData];
        [target_ performSelector:jsonOnSuccessCallback_ withObject:@{AKHHTPServiceData:dataObject,AKHTTPServiceUserInfor:userInfo_} afterDelay:0];
    } else if (rssOnSuccessCallback_) {
        AKRSSFeed *feed = [AKRSSFeed new];
        [feed parseRSSFeedData:_responseData withDelegate:self];
    } else {
        if (delegate_) {
            if ([delegate_ respondsToSelector:@selector(service:didFinishedLoadingData:)]) {
                [delegate_ service:self didFinishedLoadingData:_responseData];
            }
        }
    }
    connection_ = nil;
}

- (void)callURLRequest:(NSMutableURLRequest *)request withDelegate:(id<AKHTTPServiceDelegate>)delegate andUserInfor:(NSMutableDictionary *)userInfo
{
    delegate_ = delegate;
    userInfo_ = userInfo;
    
    [request setValue:userInfo[HEADER_FIELD_AUTHORIZATION] forHTTPHeaderField:HEADER_FIELD_AUTHORIZATION];
    [self cancelRequest];
    
    connection_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)submitJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
     andHTTPmethod:(NSString *)method
          target:(id)delegate
        userInfo:(NSMutableDictionary *)info
{
    NSLog(@"%@",url);
    jsonOnSuccessCallback_ = onSuccess;
    onFailCallback_ = onFail;
    target_ = delegate;
    userInfo_ = info;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:method];
    [request setValue:info[HEADER_FIELD_AUTHORIZATION] forHTTPHeaderField:HEADER_FIELD_AUTHORIZATION];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:HEADER_FIELD_CONTENTTYPE];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [self cancelRequest];
    connection_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)postJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
            target:(id)delegate
          userInfo:(NSMutableDictionary *)info
{
    [self submitJSON:json toURL:url withCallbackMethod:onSuccess andOnFail:onFail andHTTPmethod:@"POST" target:delegate userInfo:info];
}

- (void)putJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
          target:(id)delegate
        userInfo:(NSMutableDictionary *)info
{
    [self submitJSON:json toURL:url withCallbackMethod:onSuccess andOnFail:onFail andHTTPmethod:@"PUT" target:delegate userInfo:info];
}

- (void)postObject:(id)object toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
          target:(id)delegate
        userInfo:(NSMutableDictionary *)info
{
    NSString *json = [[self class] jsonWithObject:object];
    [self postJSON:json toURL:url withCallbackMethod:onSuccess andOnFail:onFail target:delegate userInfo:info];
}

- (void)putObject:(id)object toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
            target:(id)delegate
          userInfo:(NSMutableDictionary *)info
{
    NSString *json = [[self class] jsonWithObject:object];
    [self putJSON:json toURL:url withCallbackMethod:onSuccess andOnFail:onFail target:delegate userInfo:info];
}

- (void)loadURL:(NSURL *)url withDelegate:(id<AKHTTPServiceDelegate>)delegate userInfo:(NSMutableDictionary *)info
{
    [self loadURL:url withCachePolicy:DEFAULT_CACHEPOLICY withDelegate:delegate 
         userInfo:info];
}

- (void)loadURL:(NSURL *)url withCachePolicy:(NSURLRequestCachePolicy)cachePolicy 
   withDelegate:(id<AKHTTPServiceDelegate>)delegate userInfo:(NSMutableDictionary *)info
{
    [self loadURL:url withCachePolicy:cachePolicy timeOut:DEFAULT_TIMEOUT 
     withDelegate:delegate userInfo:info];
}

- (void)loadURL:(NSURL *)url withCachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        timeOut:(NSTimeInterval)timeoutInterval withDelegate:(id<AKHTTPServiceDelegate>)delegate
       userInfo:(NSMutableDictionary *)userInfo
{
    NSLog(@"%@",url);
    delegate_ = delegate;
    userInfo_ = userInfo;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:cachePolicy
                                                       timeoutInterval:timeoutInterval];
    [request setHTTPMethod:@"GET"];
    [request setValue:userInfo[HEADER_FIELD_AUTHORIZATION] forHTTPHeaderField:HEADER_FIELD_AUTHORIZATION];
    [request setValue:userInfo[HEADER_FIELD_CONTENTTYPE]   forHTTPHeaderField:HEADER_FIELD_CONTENTTYPE];
    [self cancelRequest];
    connection_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
         target:(id)delegate userInfo:(NSMutableDictionary *)info
{
    [self loadURL:url withCallbackMethod:onSuccess onFail:onFail 
           target:delegate cachePolicy:DEFAULT_CACHEPOLICY userInfo:info];
}

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
       userInfo:(NSMutableDictionary *)info
{
    [self loadURL:url withCallbackMethod:onSuccess onFail:onFail 
           target:delegate cachePolicy:cachePolicy 
          timeOut:DEFAULT_TIMEOUT userInfo:info];
}

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        timeOut:(NSTimeInterval)timeoutInterval userInfo:(NSMutableDictionary *)info
{
    onSuccessCallback_ = onSuccess;
    onFailCallback_ = onFail;
    target_ = delegate;
    
    [self loadURL:url withCachePolicy:cachePolicy timeOut:timeoutInterval 
     withDelegate:nil userInfo:info];
}

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
         target:(id)delegate userInfo:(NSMutableDictionary *)info
{
    [self loadJSON:url withCallbackMethod:onSuccess onFail:onFail 
           target:delegate cachePolicy:DEFAULT_CACHEPOLICY userInfo:info];
}

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        userInfo:(NSMutableDictionary *)info
{
    [self loadJSON:url withCallbackMethod:onSuccess onFail:onFail 
           target:delegate cachePolicy:cachePolicy 
          timeOut:DEFAULT_TIMEOUT userInfo:info];
}

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
         timeOut:(NSTimeInterval)timeoutInterval 
        userInfo:(NSMutableDictionary *)info
{
    jsonOnSuccessCallback_ = onSuccess;
    onFailCallback_ = onFail;
    target_ = delegate;
    
    [self loadURL:url withCachePolicy:cachePolicy timeOut:timeoutInterval withDelegate:nil userInfo:info];
}

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
          target:(id)delegate userInfo:(NSMutableDictionary *)info
{
    [self loadRSS:url withCallbackMethod:onSuccess onFail:onFail 
            target:delegate cachePolicy:DEFAULT_CACHEPOLICY userInfo:info];
}

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        userInfo:(NSMutableDictionary *)info
{
    [self loadRSS:url withCallbackMethod:onSuccess onFail:onFail 
            target:delegate cachePolicy:cachePolicy 
           timeOut:DEFAULT_TIMEOUT userInfo:info];
}

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
         timeOut:(NSTimeInterval)timeoutInterval 
        userInfo:(NSMutableDictionary *)info
{
    rssOnSuccessCallback_ = onSuccess;
    onFailCallback_ = onFail;
    target_ = delegate;
    
    [self loadURL:url withCachePolicy:cachePolicy timeOut:timeoutInterval withDelegate:nil userInfo:info];
}

- (void)didParseFeed:(AKRSSFeed *)feed toStories:(NSArray *)stories
{
    [target_ performSelector:rssOnSuccessCallback_ withObject:@{AKHHTPServiceData:stories,AKHTTPServiceUserInfor:userInfo_} afterDelay:0];
}

- (void)didFailParseFeed:(AKRSSFeed *)feed withError:(NSError *)error
{
}

@end
