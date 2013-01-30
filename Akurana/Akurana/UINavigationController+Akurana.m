//
//  UINavigationController+Akurana.m
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

#import "UINavigationController+Akurana.h"
#import "UIView+Akurana.h"
#import "UIApplication+Akurana.h"

#define AK_PUSH_TRANSITION_DURATION 0.7

@implementation UINavigationController (Akurana)

- (void)pushViewController:(UIViewController*)controller
    animatedWithTransition:(UIViewAnimationTransition)transition
{
    [self pushViewController:controller animatedWithTransition:transition withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewController:(UIViewController*)controller
    animatedWithTransition:(UIViewAnimationTransition)transition withTransitionDuration:(float)duration{
    
    [self pushViewController:controller animated:NO];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [UIView setAnimationTransition:transition forView:self.view cache:YES];
    } completion:^(BOOL finished) {
    }];
}

- (void)pushViewControllerAnimatedWithSlideFromRightTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    UIView *oldView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImage *image = [UIApplication screenshot];
    
    //This avoids color change of Status bar while the transition 
    for (UIView *view in [[self.view clone] subviews]) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            [oldView addSubview:view];
            break;
        }        
    }
    
    [oldView setBackgroundColorWithImage:image];
    [self pushViewController:controller animated:NO];
    UIView *newView = self.view;
    self.view = oldView;
    CGRect frame = newView.frame;
    frame.origin.x = frame.size.width;
    newView.frame = frame;
    [self.view addSubview:newView];
    
    frame.origin.x = 0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        newView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.view = newView;
        }
    }];

}

- (void)pushViewControllerAnimatedWithSlideFromRightTransition:(UIViewController *)controller;
{
    [self pushViewControllerAnimatedWithSlideFromRightTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewControllerAnimatedWithSlideFromLeftTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    UIView *oldView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImage *image = [UIApplication screenshot];
    
    //This avoids color change of Status bar while the transition
    for (UIView *view in [[self.view clone] subviews]) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            [oldView addSubview:view];
            break;
        }
    }
    
    [oldView setBackgroundColorWithImage:image];
    [self pushViewController:controller animated:NO];
    UIView *newView = self.view;
    self.view = oldView;
    CGRect frame = newView.frame;
    frame.origin.x = frame.size.width * -1.0;
    newView.frame = frame;
    [self.view addSubview:newView];
    
    frame.origin.x = 0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        newView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.view = newView;
        }
    }];
}

- (void)pushViewControllerAnimatedWithSlideFromLeftTransition:(UIViewController *)controller
{
    [self pushViewControllerAnimatedWithSlideFromLeftTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewControllerAnimatedWithCurlUpTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    [self pushViewController:controller animatedWithTransition:UIViewAnimationTransitionCurlUp withTransitionDuration:duration];
}

- (void)pushViewControllerAnimatedWithCurlUpTransition:(UIViewController *)controller
{
    [self pushViewControllerAnimatedWithCurlUpTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewControllerAnimatedWithCurlDownTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    [self pushViewController:controller animatedWithTransition:UIViewAnimationTransitionCurlDown withTransitionDuration:duration];
}

- (void)pushViewControllerAnimatedWithCurlDownTransition:(UIViewController *)controller
{
    [self pushViewControllerAnimatedWithCurlDownTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewControllerAnimatedWithFlipFromLeftTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    [self pushViewController:controller animatedWithTransition:UIViewAnimationTransitionFlipFromLeft withTransitionDuration:duration];
}

- (void)pushViewControllerAnimatedWithFlipFromLeftTransition:(UIViewController *)controller
{
    [self pushViewControllerAnimatedWithFlipFromLeftTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)pushViewControllerAnimatedWithFlipFromRightTransition:(UIViewController *)controller withTransitionDuration:(float)duration
{
    [self pushViewController:controller animatedWithTransition:UIViewAnimationTransitionFlipFromRight withTransitionDuration:duration];
}

- (void)pushViewControllerAnimatedWithFlipFromRightTransition:(UIViewController *)controller
{
    [self pushViewControllerAnimatedWithFlipFromRightTransition:controller withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition
{
    [self popViewControllerAnimatedWithTransition:transition withTransitionDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition withTransitionDuration:(float)duration{
    
    [self popViewControllerAnimated:NO];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [UIView setAnimationTransition:transition forView:self.view cache:YES];
    } completion:^(BOOL finished) {
    }];
}

- (void)popViewControllerWithCurlUpTransitionWithDuration:(float)duration
{
    [self popViewControllerAnimatedWithTransition:UIViewAnimationTransitionCurlUp withTransitionDuration:duration];
}

- (void)popViewControllerWithCurlUpTransition
{
    [self popViewControllerWithCurlUpTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerWithCurlDownTransitionWithDuration:(float)duration
{
    [self popViewControllerAnimatedWithTransition:UIViewAnimationTransitionCurlDown withTransitionDuration:duration];
}

- (void)popViewControllerWithCurlDownTransition
{
    [self popViewControllerWithCurlDownTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerWithFlipFromLeftTransitionWithDuration:(float)duration
{
    [self popViewControllerAnimatedWithTransition:UIViewAnimationTransitionFlipFromLeft withTransitionDuration:duration];
}

- (void)popViewControllerWithFlipFromLeftTransition
{
    [self popViewControllerWithFlipFromLeftTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerWithFlipFromRightTransitionWithDuration:(float)duration
{
    [self popViewControllerAnimatedWithTransition:UIViewAnimationTransitionFlipFromRight withTransitionDuration:duration];
}

- (void)popViewControllerWithFlipFromRightTransition
{
    [self popViewControllerWithFlipFromRightTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerWithSlideFromLeftTransitionWithDuration:(float)duration
{
    
    UIView *oldView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImage *image = [UIApplication screenshot];
    
    [oldView setBackgroundColorWithImage:image];
    
    [self popViewControllerAnimated:NO];
    
    CGRect frame = oldView.frame;
    
    [self.view addSubview:oldView];
    
    frame.origin.x = self.view.frame.size.width * -1.0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        oldView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [oldView removeFromSuperview];
        }
    }];
    
}

- (void)popViewControllerWithSlideFromLeftTransition
{
    [self popViewControllerWithSlideFromLeftTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

- (void)popViewControllerWithSlideFromRightTransitionWithDuration:(float)duration
{
    UIView *oldView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImage *image = [UIApplication screenshot];
    
    [oldView setBackgroundColorWithImage:image];
    
    [self popViewControllerAnimated:NO];
    
    CGRect frame = oldView.frame;
    
    [self.view addSubview:oldView];
    
    frame.origin.x = self.view.frame.size.width;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        oldView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [oldView removeFromSuperview];
        }
    }];
}

- (void)popViewControllerWithSlideFromRightTransition
{
    [self popViewControllerWithSlideFromRightTransitionWithDuration:AK_PUSH_TRANSITION_DURATION];
}

@end
