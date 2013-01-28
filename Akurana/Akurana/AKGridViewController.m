//
//  AKGridViewController.m
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

#import "AKGridViewController.h"
#import "AKGlobal.h"

@interface AKGridViewController ()

@end

@implementation AKGridViewController

- (float)topMarginOfGridView:(AKGridView *)gridView;
{
    return 0;
}

- (float)sideMarginOfGridView:(AKGridView *)gridView
{
    return 0;
}

- (float)columnWithOfGridView:(AKGridView *)gridView
{
    return self.view.frame.size.width;
}

- (float)rowHeightOfGridView:(AKGridView *)gridView
{
    return self.view.frame.size.height;
}

- (NSInteger)numberOfColumOfGridView:(AKGridView *)gridView
{
    return 1;
}

- (NSInteger)numberOfRowOfGridView:(AKGridView *)gridView
{
     return 1;
}

- (NSInteger)numberOfViewsOfGridView:(AKGridView *)gridView
{
    mustOverride();
}

- (UIView *)gridView:(AKGridView *)gridView viewAtIndex:(NSInteger)index
{
    mustOverride();
}

- (void)loadView
{
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat tabBarHeight = self.tabBarController.tabBar.hidden ? 0.0f : self.tabBarController.tabBar.bounds.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBarHidden ? 0.0f : self.navigationController.navigationBar.bounds.size.height;    
    frame.size.height = frame.size.height - navBarHeight - tabBarHeight;
    
    if (![UIApplication sharedApplication].statusBarHidden) {
        frame.size.height = frame.size.height - 20.0;
    }
    
    AKGridView *view = [[AKGridView alloc] init];
    self.view = view;
    view.delegate = self;
    view.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AKGridView *view =  (AKGridView *)self.view;
    [view reaLoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
