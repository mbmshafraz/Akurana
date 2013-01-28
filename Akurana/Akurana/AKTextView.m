//
//  AKTextView.m
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

#import "AKTextView.h"

#define DEFAULT_RED 0.0
#define DEFAULT_GREEN 0.0
#define DEFAULT_BLUE 0.0

@interface AKTextView ()

- (void)initialize;
- (void)drawCenterAlignedTextInContext:(CGContextRef)context;
- (void)drawLeftAlignedTextInContext:(CGContextRef)context;
- (void)drawRightAlignedTextInContext:(CGContextRef)context;
- (void)drawJustifiedTextInContext:(CGContextRef)context;
- (void)resizeView;

@end

@implementation AKTextView


+ (CGFloat)heightText:(NSString *)text withFont:(UIFont*)font lineWidth:(CGFloat)width lineSpace:(float)lineSpace
{
    CGFloat height = 0.0f;
    
    CGSize charSize = [@" " sizeWithFont:font];
    CGFloat x = 0.0f;
    
    NSArray *paragraphs = [text componentsSeparatedByString:@"\n"];
    
    for (NSString *paragraph in paragraphs) {
        
        NSArray *words = [paragraph componentsSeparatedByString:@" "];
        
        x = 0.0f;
        for (NSString *word in words) {
            
            if (x + [word sizeWithFont:font].width > width) {
                x = 0.0;
                height = height + charSize.height - 5.0 + lineSpace;
            }
            
            x = x + [word sizeWithFont:font].width + charSize.width;
        }
        
        height = height + charSize.height - 5.0 + lineSpace;
    }
    
    return height-lineSpace;
}


- (void)initialize
{
    _textColor = [UIColor blackColor];
    _fontSize = 14;
    _font = [UIFont systemFontOfSize:_fontSize] ;
    _linSpace = 3.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init
{
    self =  [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    switch (_textAlignment) {
        case AKTextAlignmentJustified:
            [self drawJustifiedTextInContext:UIGraphicsGetCurrentContext()];
            break;
        case AKTextAlignmentRight:
            [self drawRightAlignedTextInContext:UIGraphicsGetCurrentContext()];
            break;
        case AKTextAlignmentCenter:
            [self drawCenterAlignedTextInContext:UIGraphicsGetCurrentContext()];
            break;
        case AKTextAlignmentLeft:
        default:
            [self drawLeftAlignedTextInContext:UIGraphicsGetCurrentContext()];
            break;
    }
}

- (void)drawJustifiedTextInContext:(CGContextRef)context
{
    CGColorRef colorref = [_textColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(colorref);
    const CGFloat *components = CGColorGetComponents(colorref);
    //Default black color
    CGFloat red   = DEFAULT_RED;
    CGFloat green = DEFAULT_GREEN;
    CGFloat blue  = DEFAULT_BLUE;
    CGFloat alpha = 1.0f;
    
    if (numComponents == 4) {
        
        red     = components[0];
        green   = components[1];
        blue    = components[2];
        alpha   = components[3];
        
    } else if (numComponents == 2) {
        
        red     = components[0];
        green   = components[0];
        blue    = components[0];
        alpha   = components[1];
    }
    

    CGContextSetRGBFillColor(context, red, green, blue, alpha);
	CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    CGContextSelectFont(context, [_font.fontName UTF8String], _fontSize, kCGEncodingMacRoman);
	// Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);
	//CGContextShowTextAtPoint(context, 10.0, 30.0, [_text UTF8String], strlen([_text UTF8String]));
    
    CGSize charSize = [@" " sizeWithFont:_font];
    CGFloat x = 0.0f;
    CGFloat y = 1.0 + charSize.height/2.0;
    
    NSArray *paragraphs = [_text componentsSeparatedByString:@"\n"];
    
    for (NSString *paragraph in paragraphs) {
        BOOL isLastLine = NO;
        
        NSArray *words = [paragraph componentsSeparatedByString:@" "];
        int wordCount = [words count];
        
        for (int i=0; i<wordCount; i++) {
            NSMutableArray *line = [NSMutableArray new];
            NSString *word = words[i];
            CGFloat width = [word sizeWithFont:_font].width;
            CGFloat space = 0.0f;
            
            //Constracting line
            
            while (TRUE) {
                [line addObject:word];
                
                if (wordCount==i+1) { //Last word
                    isLastLine = YES;
                    break;
                } else {
                    word = words[i+1];
                    if (width + space + charSize.width + [word sizeWithFont:_font].width >= self.frame.size.width) {
                        break;
                    }
                    i++;
                    space += charSize.width;
                    width += [word sizeWithFont:_font].width;
                }
            }
            
            CGFloat spaceWidth;
            CGFloat xSpace;
            int spaceCount = [line count] > 1 ? [line count]-1 : 1;
            if (isLastLine) {
                spaceWidth = charSize.width;
                xSpace = 0.0f;
            } else {
                space = self.frame.size.width - width;
                spaceWidth = (int)(space/spaceCount);
                xSpace = space - (spaceWidth * spaceCount);
            }
            
            //Printing line
            x = 0.0;
            for (NSString *word in line) {
                CGContextShowTextAtPoint(context, x, y, [word UTF8String], strlen([word UTF8String]));
                x = x + spaceWidth + [word sizeWithFont:_font].width;
                if (xSpace > 0.0) {
                    x += 1.0;
                    xSpace -= 1.0;
                }
            }
            
            //Moving to next line
            y = y + charSize.height - 5.0 + _linSpace;
        }
    }
}

- (void)drawLeftAlignedTextInContext:(CGContextRef)context
{
    CGColorRef colorref = [_textColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(colorref);
    const CGFloat *components = CGColorGetComponents(colorref);
    //Default black color
    CGFloat red   = DEFAULT_RED;
    CGFloat green = DEFAULT_GREEN;
    CGFloat blue  = DEFAULT_BLUE;
    CGFloat alpha = 1.0f;
    
    if (numComponents == 4) {
        
        red     = components[0];
        green   = components[1];
        blue    = components[2];
        alpha   = components[3];
        
    } else if (numComponents == 2) {
        
        red     = components[0];
        green   = components[0];
        blue    = components[0];
        alpha   = components[1];
    }

    
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
	CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    CGContextSelectFont(context, [_font.fontName UTF8String], _fontSize, kCGEncodingMacRoman);
	// Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);
	//CGContextShowTextAtPoint(context, 10.0, 30.0, [_text UTF8String], strlen([_text UTF8String]));
    
    CGSize charSize = [@" " sizeWithFont:_font];
    CGFloat x = 0.0f;
    CGFloat y = 1.0 + charSize.height/2.0;
    
    NSArray *paragraphs = [_text componentsSeparatedByString:@"\n"];
    
    for (NSString *paragraph in paragraphs) {
        
        NSArray *words = [paragraph componentsSeparatedByString:@" "];
        
        x = 0.0f;
        for (NSString *word in words) {
            
            if (x + [word sizeWithFont:_font].width > self.frame.size.width) {
                x = 0.0;
                y = y + charSize.height - 5.0 + _linSpace;
            }
            
            CGContextShowTextAtPoint(context, x, y, [word UTF8String], strlen([word UTF8String]));
            x = x + [word sizeWithFont:_font].width + charSize.width;
        }
        
        y = y + charSize.height - 5.0 + _linSpace;
    }
}

- (void)drawRightAlignedTextInContext:(CGContextRef)context
{
    CGColorRef colorref = [_textColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(colorref);
    const CGFloat *components = CGColorGetComponents(colorref);
    //Default black color
    CGFloat red   = DEFAULT_RED;
    CGFloat green = DEFAULT_GREEN;
    CGFloat blue  = DEFAULT_BLUE;
    CGFloat alpha = 1.0f;
    
    if (numComponents == 4) {
        
        red     = components[0];
        green   = components[1];
        blue    = components[2];
        alpha   = components[3];
        
    } else if (numComponents == 2) {
        
        red     = components[0];
        green   = components[0];
        blue    = components[0];
        alpha   = components[1];
    }
    
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
	CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    CGContextSelectFont(context, [_font.fontName UTF8String], _fontSize, kCGEncodingMacRoman);
	// Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);
	//CGContextShowTextAtPoint(context, 10.0, 30.0, [_text UTF8String], strlen([_text UTF8String]));
    
    CGSize charSize = [@" " sizeWithFont:_font];
    CGFloat x = 0.0f;
    CGFloat y = 1.0 + charSize.height/2.0;
    
    NSArray *paragraphs = [_text componentsSeparatedByString:@"\n"];
    
    for (NSString *paragraph in paragraphs) {
        
        NSArray *words = [paragraph componentsSeparatedByString:@" "];
        int wordCount = [words count];
        
        for (int i=0; i<wordCount; i++) {
            NSString *line = [NSString new];
            NSString *word = words[i];
            x = 0.0f;
            while (TRUE) {
                if (x + charSize.width + [word sizeWithFont:_font].width > self.frame.size.width) {
                    i--;
                    break;
                } else {
                    x = x + charSize.width + [word sizeWithFont:_font].width;
                    //line = [line stringByAppendingFormat:@"%@%@",word,@" "];
                    line = [line stringByAppendingString:word];
                    i++;
                    if (i==wordCount) {
                        break;
                    }
                    word = words[i];
                    line = [line stringByAppendingString:@" "];
                }
            }
            
            NSString *trimedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            x = self.frame.size.width - [trimedLine sizeWithFont:_font].width;
            
            CGContextShowTextAtPoint(context, x, y, [trimedLine UTF8String], strlen([trimedLine UTF8String]));
            y = y + charSize.height - 5.0 + _linSpace;
            
        }
    }
}

- (void)drawCenterAlignedTextInContext:(CGContextRef)context
{
    CGColorRef colorref = [_textColor CGColor];
    
    int numComponents = CGColorGetNumberOfComponents(colorref);
    const CGFloat *components = CGColorGetComponents(colorref);
    //Default black color
    CGFloat red   = DEFAULT_RED;
    CGFloat green = DEFAULT_GREEN;
    CGFloat blue  = DEFAULT_BLUE;
    CGFloat alpha = 1.0f;
    
    if (numComponents == 4) {
        
        red     = components[0];
        green   = components[1];
        blue    = components[2];
        alpha   = components[3];
        
    } else if (numComponents == 2) {
        
        red     = components[0];
        green   = components[0];
        blue    = components[0];
        alpha   = components[1];
    }

    
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
	CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    CGContextSelectFont(context, [_font.fontName UTF8String], _fontSize, kCGEncodingMacRoman);
	// Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(context, kCGTextFill);
	//CGContextShowTextAtPoint(context, 10.0, 30.0, [_text UTF8String], strlen([_text UTF8String]));
    
    CGSize charSize = [@" " sizeWithFont:_font];
    CGFloat x = 0.0f;
    CGFloat y = 1.0 + charSize.height/2.0;
    
    NSArray *paragraphs = [_text componentsSeparatedByString:@"\n"];
    
    for (NSString *paragraph in paragraphs) {
        
        NSArray *words = [paragraph componentsSeparatedByString:@" "];
        int wordCount = [words count];
        
        for (int i=0; i<wordCount; i++) {
            NSString *line = [NSString new];
            NSString *word = words[i];
            x = 0.0f;
            while (TRUE) {
                if (x + charSize.width + [word sizeWithFont:_font].width > self.frame.size.width) {
                    i--;
                    break;
                } else {
                    x = x + charSize.width + [word sizeWithFont:_font].width;
                    //line = [line stringByAppendingFormat:@"%@%@",word,@" "];
                    line = [line stringByAppendingString:word];
                    i++;
                    if (i==wordCount) {
                        break;
                    }
                    word = words[i];
                    line = [line stringByAppendingString:@" "];
                }
            }
            line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            x = (self.frame.size.width - [line sizeWithFont:_font].width)/2.0;
            
            CGContextShowTextAtPoint(context, x, y, [line UTF8String], strlen([line UTF8String]));
            y = y + charSize.height - 5.0 + _linSpace;
        }
    }
}

- (void)resizeView
{
    if (_resizeToTextHeight) {
        CGRect frame = self.frame;
        CGSize frameSize = frame.size;
        frameSize.height = [AKTextView heightText:_text withFont:_font lineWidth:frame.size.width lineSpace:_linSpace];
        
        frame.size = frameSize;
        self.frame = frame;
        [_delegate resizedTextView:self];
    }
}

- (void) setText:(NSString *)text
{
    _text = text;
    
    [self resizeView];
}

- (void) setTextAlignment:(AKTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}

- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void) setFont:(UIFont *)font
{
    _font  = font;
    _fontSize  = font.pointSize;
    [self resizeView];
    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [self resizeView];
    [self setNeedsDisplay];
}

- (void)setResizeToTextHeight:(BOOL)resizeToTextHeight
{
    _resizeToTextHeight = resizeToTextHeight;
    if (_resizeToTextHeight) {
        [self resizeView];
        [self setNeedsDisplay];
    }
}

- (void)setLinSpace:(CGFloat)linSpace
{
    _linSpace = linSpace;
    [self resizeView];
    [self setNeedsDisplay];
}

@end
