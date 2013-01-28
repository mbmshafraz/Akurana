//
//  AKImageEntity.m
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

#import "AKImageItem.h"

@implementation AKImageEntity

#pragma mark Public

- (id)initWithURL:(NSString *)url thumbURL:(NSString *)thumbURL
  size:(CGSize)size caption:(NSString *)caption
{
    if (self = [super init]) {
        self.url      = url;
        self.thumbURL = thumbURL;
        self.thumbURL = thumbURL;
        self.size     = size;
        self.caption  = caption;
        self.index = NSIntegerMax;
    }
    return self;
}

- (id)initWithURL:(NSString *)url thumbURL:(NSString *)thumbURL
  size:(CGSize)size
{
    return [self initWithURL:url thumbURL:thumbURL size:size caption:nil];
}

- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSString *)baseURL
{
    if (dict == nil) {
        return nil;
    }
    
    NSString *url = [baseURL stringByAppendingPathComponent:dict[@"uri"]];
    NSString *thumbURL = [baseURL stringByAppendingPathComponent:dict[@"thumb_uri"]];
    NSString *caption = dict[@"caption"];
    CGSize size = CGSizeMake(0, 0);
    
    return [self initWithURL:url thumbURL:thumbURL size:size caption:caption];
}

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (_url) dic[@"url"] = _url;
    if (_thumbURL) dic[@"thumb_uri"] = _thumbURL;
    if (_caption) dic[@"caption"] = _caption;
    
    return dic;
}

- (NSString *)urlForVersion:(AKImageVersion)version
{
    if (version == AKImageVersionLarge) {
        return _url;
    } else if (version == AKImageVersionMedium) {
        return _url;
    } else if (version == AKImageVersionSmall) {
        return _thumbURL;
    } else if (version == AKImageVersionThumbnail) {
        return _thumbURL;
    } else {
        return nil;
    }
}

@end
