//
//  AKResource.m
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

#import "AKResource.h"

static AKResource *sharedResource = nil;

@interface AKResource()

@property (nonatomic, strong, readwrite) NSString *rootPath;

+ (NSString *)getImagePath:(NSString *)name;

@end

@implementation AKResource

+ (AKResource *)sharedResource
{
    @synchronized(self) {
        if (sharedResource == nil) {
            sharedResource = [self new];
        }
    }
    
    return sharedResource;
}

- (id)init
{
	if (self = [super init])
    {
		self.rootPath = [[[NSBundle mainBundle] pathForResource:@"Akurana"
                                                         ofType:@"bundle"]
                         stringByAppendingString:@"/"];
        NSAssert(_rootPath, @"Akurana.budnle not found, Please add the bundle to your main project from Resource folder of Akurana Library");
	}
	
	return self;
}

+ (NSString *)getImagePath:(NSString *)name
{
    
    return [NSString stringWithFormat:@"%@images/%@",[AKResource sharedResource].rootPath,name];
}

+ (UIImage *)getImage:(NSString *)name
{
    //return [UIImage imageWithContentsOfFile:[AKResource getImagePath:name]];
    return [UIImage imageWithContentsOfFile:[AKResource getImagePath:name]];
}
@end
