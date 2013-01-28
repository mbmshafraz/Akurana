//
//  AKViewController.m
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


#import "AKViewController.h"
#import "AKGlobal.h"
#import "AKTheme.h"

@interface AKViewController ()

@end

@implementation AKViewController


- (id)init
{
    if (self = [super init]) {
        self.portraitBackground = AK_BACKGROUND_IMAGE_PORTRAIT;
        self.landscapeBackground = AK_BACKGROUND_IMAGE_LANDSCAPE;
    }
    return self;
}

- (void)setPortraitBackground:(NSString *)image
{
    portraitBackgroundColor_ = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:image]];
}

- (void)setLandscapeBackground:(NSString *)image
{
    landscapeBackgroundColor_ = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:image]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (UIInterfaceOrientationPortrait == [[UIDevice currentDevice] orientation]
        ||UIInterfaceOrientationPortraitUpsideDown==[[UIDevice currentDevice] orientation]) {
        [self layoutForPortrait];
    } else {
        [self layoutForLandscape];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UIInterfaceOrientationPortrait == [[UIDevice currentDevice] orientation]
        ||UIInterfaceOrientationPortraitUpsideDown==[[UIDevice currentDevice] orientation]) {
        [self layoutForPortrait];
    } else {
        [self layoutForLandscape];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationLandscapeRight==interfaceOrientation;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                         duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait
        || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self layoutForPortrait];
    } else {
        [self layoutForLandscape];
    }
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)layoutForPortrait
{   
    self.parentViewController.view.backgroundColor = portraitBackgroundColor_;
}

- (void)layoutForLandscape
{
    self.parentViewController.view.backgroundColor = landscapeBackgroundColor_;
}

@end
