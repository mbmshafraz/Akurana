//
//  AKImageView.m
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

#import "AKImageView.h"
#import "UIImageView+Akurana.h"

@implementation AKImageView


- (void)layoutWithFrame:(CGRect)frame
{
    CGSize size = frame.size;
    imageView_.frame = CGRectMake(0, 0,size.width, size.height);
    activityIndicator_.frame = CGRectMake((size.width - 21)/2.0, (size.height - 21)/2.0, 21, 21);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        imageView_ = [UIImageView new];
        [self addSubview:imageView_];
        
        activityIndicator_ = [UIActivityIndicatorView new];
        [self addSubview:activityIndicator_];
        
        [self layoutWithFrame:frame];
        httpService_ = [AKHTTPService new];
    }
    return self;
}

-(void) setDefaultImage:(UIImage *)defaultImage
{
    _defaultImage = defaultImage;
    imageView_.image = defaultImage;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    [self layoutWithFrame:frame];
}

- (void)setImage:(UIImage *)image
{
    imageView_.image = image;
}

- (UIImage *)image
{
    return imageView_.image;
}

- (void)setImageURL:(NSString *)url
{
    [self setImageURL:url withUserInfo:nil];
}

- (void)setImageURL:(NSString *)url withUserInfo:(NSDictionary *)info
{
    imageView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSURL *nsUrl = [NSURL URLWithString:url];
    [self setImageNSURL:nsUrl withUserInfo:info];
}

- (void)setImageNSURL:(NSURL *)url
{
    [self setImageNSURL:url withUserInfo:nil];
}

- (void)setImageNSURL:(NSURL *)url withUserInfo:(NSDictionary *)info
{
    imageView_.image = _defaultImage;
    [activityIndicator_ startAnimating];
    [httpService_ loadURL:url withDelegate:self userInfo:info];
}

- (void)service:(AKHTTPService *)service didFinishedLoadingData:(NSData *)data
{
    NSLog(@"Code - %d",httpService_.responseCode);
    if(httpService_.responseCode == 200)
    {
        UIImage *image = [[UIImage alloc] initWithData:data];
        [imageView_ setImageWithoutStrach:image];
    }
    [activityIndicator_ stopAnimating];
}

- (void)service:(AKHTTPService *)service didFailWithError:(NSError *)error
{
    [activityIndicator_ stopAnimating];
}

@end
