//
//  AKTheme.m
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

#import "AKTheme.h"
#import "UIColor+Akurana.h"
#import "NSString+Akurana.h"

static AKTheme *sharedTheme = nil;

@interface AKTheme ()
@property (nonatomic, strong, readwrite) NSDictionary *config;
@property (nonatomic, strong, readwrite) NSString *rootPath;
@end

@implementation AKTheme


#pragma mark Public

+ (AKTheme *)sharedTheme
{
    @synchronized(self) {
        if (sharedTheme == nil) {
            sharedTheme = [self new];
        }
    }
    return sharedTheme;
}


- (UIColor *)colorForRGB:(NSString *)key
{
	SEL selector;
	selector= NSSelectorFromString([_config valueForKey:key]);
	UIColor *color = nil;
	if ([UIColor respondsToSelector:selector])
		color = [UIColor performSelector:selector];
    return color;
}

- (UIColor *)colorForKeyRGBA:(NSString *)key
{
    NSString *colorCode = [_config valueForKey:key];
    
    return [UIColor colorWithRGBA:[colorCode hexValue]];

}


- (UIColor *)colorForKeyRGB:(NSString *)key
{
    NSString *colorCode = [_config valueForKey:key];
    
    return [UIColor colorWithRGB:[colorCode hexValue]];
}

- (NSDictionary *)colorRgbForKey:(NSString *)key
{
    return [_config valueForKey:key];
}

- (UIImage *)getBackgroundImage
{
    NSString *backgroundImageName = [_config valueForKey:BackgroundImage];
    return [[self class] getImage:backgroundImageName];
}

#pragma mark NSObject

- (id)init
{
	if (self = [super init])
    {
		self.rootPath = [[[NSBundle mainBundle] pathForResource:@"Theme"
                                                              ofType:@"bundle"]
                         stringByAppendingString:@"/"];
        NSString *plistPath = [self.rootPath stringByAppendingString:@"Theme.plist"]; 
        
        [self setConfig:[[NSDictionary alloc]
                          initWithContentsOfFile:plistPath]];
	}
	
	return self;
}

+ (NSString *)getImagePath:(NSString *)name
{
    
    return [NSString stringWithFormat:@"%@images/%@",[AKTheme sharedTheme].rootPath,name];
}

+ (UIImage *)getImage:(NSString *)name
{
    return [UIImage imageWithContentsOfFile:[AKTheme getImagePath:name]];
}

@end
