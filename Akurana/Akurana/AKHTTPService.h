//
//  AKHTTPService.h
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

#import <Foundation/Foundation.h>
#import "AKRSSFeed.h"

#define HEADER_FIELD_AUTHORIZATION @"Authorization"
#define HEADER_FIELD_CONTENTTYPE   @"Content-Type"
#define AKHTTPServiceError @"error"
#define AKHTTPServiceUserInfor @"user_info"
#define AKHHTPServiceData @"data"

@class AKHTTPService;
@class AKRSSFeed;


@protocol AKHTTPServiceDelegate <NSObject>

@optional
- (void)service:(AKHTTPService *)service didFinishedLoadingData:(NSData *)data;
- (void)service:(AKHTTPService *)service didFailWithError:(NSError *)error;
- (void)didCancelledService:(AKHTTPService *)service;
@end



@interface AKHTTPService : NSObject <AKRSSFeedDelegate>{
    id<AKHTTPServiceDelegate> delegate_;
    SEL onSuccessCallback_;
    SEL jsonOnSuccessCallback_;
    SEL rssOnSuccessCallback_;
    SEL onFailCallback_;
    id  target_;
    NSMutableDictionary *userInfo_;
    NSURLConnection *connection_;
}

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, assign) NSInteger responseCode;

+ (NSString *)stringWithData:(NSData *)data;

+ (id)objectWithData:(NSData *)data;

- (void)cancelRequest;

- (void)loadURL:(NSURL *)url withDelegate:(id<AKHTTPServiceDelegate>)delegate 
       userInfo:(NSDictionary *)info;

- (void)loadURL:(NSURL *)url withCachePolicy:(NSURLRequestCachePolicy)cachePolicy 
   withDelegate:(id<AKHTTPServiceDelegate>)delegate userInfo:(NSDictionary *)info;

- (void)loadURL:(NSURL *)url withCachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        timeOut:(NSTimeInterval)timeoutInterval 
   withDelegate:(id<AKHTTPServiceDelegate>)delegate userInfo:(NSDictionary *)info;

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
         target:(id)delegate userInfo:(NSDictionary *)info;

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
       userInfo:(NSDictionary *)info;

- (void)loadURL:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        timeOut:(NSTimeInterval)timeoutInterval userInfo:(NSDictionary *)info;

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
         target:(id)delegate userInfo:(NSDictionary *)info;

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        userInfo:(NSDictionary *)info;

- (void)loadJSON:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
         target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        timeOut:(NSTimeInterval)timeoutInterval userInfo:(NSDictionary *)info;

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail
          target:(id)delegate userInfo:(NSDictionary *)info;

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
        userInfo:(NSDictionary *)info;

- (void)loadRSS:(NSURL *)url withCallbackMethod:(SEL)onSuccess onFail:(SEL)onFail 
          target:(id)delegate cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
         timeOut:(NSTimeInterval)timeoutInterval userInfo:(NSDictionary *)info;

- (void)callURLRequest:(NSMutableURLRequest *)request withDelegate:(id<AKHTTPServiceDelegate>)delegate
          andUserInfor:(NSMutableDictionary *)userInfo;

- (void)submitJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
     andHTTPmethod:(NSString *)method
            target:(id)delegate
          userInfo:(NSMutableDictionary *)info;

- (void)postJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
          target:(id)delegate
        userInfo:(NSMutableDictionary *)info;

- (void)putJSON:(NSString *)json toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
         target:(id)delegate
       userInfo:(NSMutableDictionary *)info;

- (void)postObject:(id)object toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
            target:(id)delegate
          userInfo:(NSMutableDictionary *)info;

- (void)putObject:(id)object toURL:(NSURL*)url withCallbackMethod:(SEL)onSuccess andOnFail:(SEL)onFail
           target:(id)delegate
         userInfo:(NSMutableDictionary *)info;
@end
