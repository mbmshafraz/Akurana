//
//  AKPageView.m
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

#import "AKPageView.h"

@interface AKPageView (Private)

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

- (void)showPage:(NSInteger)page;

@end


@implementation AKPageView

@dynamic pageCount;

- (id)init
{
    if (self = [super init]) {
        self.scrollView = [UIScrollView new];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        [super addSubview:_scrollView];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        [self.pageControl addTarget:self action:@selector(changePage:)
               forControlEvents:UIControlEventValueChanged];
        [super addSubview:_pageControl];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame;
{
    super.frame = frame;
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _pageControl.frame = CGRectMake(0, frame.size.height - 30,
                                    frame.size.width, 20);
}

- (void)addSubview:(UIView *)view
{
    [_scrollView addSubview:view];
}


- (void) setPageCount:(NSInteger)count
{
    numberOfPages_ = count;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * count, _scrollView.frame.size.height);
    _pageControl.numberOfPages = count;
}

- (void)changePage:(id)sender
{
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed_ = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (pageControlUsed_) {
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed_ = NO;
    
    if (previousPage_ != _pageControl.currentPage) {
        previousPage_ = _pageControl.currentPage;
        
        [self loadPage:_pageControl.currentPage];
    }
}

- (void)changeToPage:(NSInteger)page
{
    _pageControl.currentPage = page;
    [self changePage:nil];
    pageControlUsed_ = NO;
}

- (void)loadPage:(NSInteger)page
{
        [_delegate pageView:self changedToPage:page];
}

@end
