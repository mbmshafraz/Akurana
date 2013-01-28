//
//  AKGridView.m
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

#import "AKGridView.h"
#import "AKPageView.h"

@implementation AKGridView

- (void)reaLoadData
{
    [[self.scrollView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    numberOfThumbs_ = [self.delegate numberOfViewsOfGridView:self];
    
    if (numberOfThumbs_ < 1) {
        return;
    }
    
    topMargin_  = [self.delegate topMarginOfGridView:self];
    sideMargin_ = [self.delegate sideMarginOfGridView:self];
    columnWith_ = [self.delegate columnWithOfGridView:self];
    rowHeight_  = [self.delegate rowHeightOfGridView:self];
    numberOfColum_ = [self.delegate numberOfColumOfGridView:self];
    numberOfRow_ = [self.delegate numberOfRowOfGridView:self];
    
    loadedPages_ = [NSMutableArray new];
    
    int thumbPerPage = numberOfColum_ * numberOfRow_;
    
    CGFloat pageWidth = self.frame.size.width;
    CGFloat pageHeight = self.frame.size.height;
    
    rowSpace_ = 0;
    if (numberOfRow_ > 1) {
        rowSpace_ = ((pageHeight - (2*topMargin_)-(numberOfRow_*rowHeight_))/(numberOfRow_ - 1));
    }
    
    colSpace_ = 0;
    if (numberOfColum_ > 1) {
        colSpace_ = ((pageWidth - (2*sideMargin_)-(numberOfColum_ * columnWith_))/(numberOfColum_ - 1));
    }
    
    int pageCount = numberOfThumbs_ / thumbPerPage;
    
    if (numberOfThumbs_ % thumbPerPage > 0) {
        pageCount++;
    }
    
    self.pageCount = pageCount;
        
    if ([self.delegate respondsToSelector:@selector(selectedPageOfThumListView:)]) {
        [self changeToPage:[self.delegate selectedPageOfGridView:self]];
    }
    
    [self loadPage:self.pageControl.currentPage];
}

- (void)loadPage:(NSInteger)page
{
    [super loadPage:page];
    for (NSNumber *indix in loadedPages_) {
        if ([indix intValue] == page) {
            return;
        }
    }
    
    [loadedPages_ addObject:@(page)];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat pageSpace = 0;
    CGFloat pageWidth = self.frame.size.width;
    
    NSInteger index = numberOfColum_ * numberOfRow_ * page;
    
    pageSpace = (page * pageWidth) + sideMargin_;
    for (int row = 0; row < numberOfRow_ ; row++) {
        for (int col = 0; col < numberOfColum_ ; col++) {
            x = pageSpace + (col * (colSpace_ + columnWith_));
            y = topMargin_ + (row * (rowSpace_ + rowHeight_));
            
            UIView *thumb = [self.delegate gridView:self viewAtIndex:index];
            thumb.frame = CGRectMake(x, y, columnWith_, rowHeight_);

            [self.scrollView addSubview:thumb];

            index++;
            if (index >= numberOfThumbs_) {
                return;
            } 
        }
    }   
}

@end
