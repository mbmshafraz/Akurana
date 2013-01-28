//
//  AKScrollerbleTextArea.m
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

#import "AKScrollerbleTextView.h"

@interface AKScrollerbleTextView()

- (void)initialize;

@end

@implementation AKScrollerbleTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self setFrame:frame];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    textView_ = [AKTextView new];
    textView_.backgroundColor = [UIColor clearColor];
    textView_.resizeToTextHeight = YES;
    textView_.delegate = self;
    self.topMargin = 10.0f;
    self.bottomMargin = 10.0f;
    self.leftMargin = 10.0f;
    self.rightMargin = 10.0f;
    
    [self addSubview:textView_];
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    textView_.frame = CGRectMake(_leftMargin, _topMargin, frame.size.width - (_leftMargin + _rightMargin), frame.size.height-(_topMargin + _bottomMargin));
}


- (void)setText:(NSString *)text
{
    textView_.text = text;
}

- (NSString *)text
{
    return textView_.text;
}

- (void)setTextAlignment:(AKTextAlignment) textAlignment
{
    textView_.textAlignment = textAlignment;
}

- (AKTextAlignment) textAlignment
{
    return textView_.textAlignment;
}

- (void)setTextColor:(UIColor *)textColor
{
    textView_.textColor = textColor;
}

- (UIColor *)textColor
{
    return textView_.textColor;
}

- (void)setFont:(UIFont *)font
{
    textView_.font = font;
}

- (UIFont *)font
{
    return textView_.font;
}

- (void)setFontSize:(CGFloat)fontSize
{
    textView_.fontSize = fontSize;
}

- (CGFloat)fontSize
{
    return textView_.fontSize;
}

- (void)resizedTextView:(AKTextView *)textView
{
    self.contentSize = CGSizeMake(textView.frame.size.width, textView.frame.size.height + _topMargin + _bottomMargin);
}

@end
