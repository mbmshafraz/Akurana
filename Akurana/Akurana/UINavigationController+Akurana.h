//
//  UINavigationController+Akurana.h
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

#import <UIKit/UIKit.h>

@interface UINavigationController (Akurana)

/*
 * Pushing view controllers with standed transitions
 */
- (void)pushViewController:(UIViewController*)controller
    animatedWithTransition:(UIViewAnimationTransition)transition
    withTransitionDuration:(float)duration;

- (void)pushViewController:(UIViewController*)controller
    animatedWithTransition:(UIViewAnimationTransition)transition;

/*
 * Poping view controllers with standed transitions
 */
- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition
                         withTransitionDuration:(float)duration;

- (void)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

/*
 * Pushing view controllers with Curl up transitions
 */
- (void)pushViewControllerAnimatedWithCurlUpTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithCurlUpTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Curl up transitions
 */
- (void)popViewControllerWithCurlUpTransitionWithDuration:(float)duration;
- (void)popViewControllerWithCurlUpTransition;

/*
 * Pushing view controllers with Curl down transitions
 */
- (void)pushViewControllerAnimatedWithCurlDownTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithCurlDownTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Curl down transitions
 */
- (void)popViewControllerWithCurlDownTransitionWithDuration:(float)duration;
- (void)popViewControllerWithCurlDownTransition;

/*
 * Pushing view controllers with Flip from Left transitions
 */
- (void)pushViewControllerAnimatedWithFlipFromLeftTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithFlipFromLeftTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Flip from Left transitions
 */
- (void)popViewControllerWithFlipFromLeftTransitionWithDuration:(float)duration;
- (void)popViewControllerWithFlipFromLeftTransition;

/*
 * Pushing view controllers with Flip from Right transitions
 */
- (void)pushViewControllerAnimatedWithFlipFromRightTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithFlipFromRightTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Flip from Right transitions
 */
- (void)popViewControllerWithFlipFromRightTransitionWithDuration:(float)duration;
- (void)popViewControllerWithFlipFromRightTransition;

/*
 * Pushing view controllers with Sliding from Right transitions
 */
- (void)pushViewControllerAnimatedWithSlideFromRightTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithSlideFromRightTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Sliding to Right transitions
 */
- (void)popViewControllerWithSlideToRightTransitionWithDuration:(float)duration;
- (void)popViewControllerWithSlideToRightTransition;

/*
 * Pushing view controllers with Sliding from Left transitions
 */
- (void)pushViewControllerAnimatedWithSlideFromLeftTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithSlideFromLeftTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Sliding to Left transitions
 */
- (void)popViewControllerWithSlideToLeftTransitionWithDuration:(float)duration;
- (void)popViewControllerWithSlideToLeftTransition;

/*
 * Pushing view controllers with Sliding Super Controller to Left transitions
 */
- (void)pushViewControllerAnimatedWithSlideSuperControllerToLeftTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithSlideSuperControllerToLeftTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Sliding Super Controller from Left transitions
 */
- (void)popViewControllerWithSlideSuperControllerFromLeftTransitionWithDuration:(float)duration;
- (void)popViewControllerWithSlideSuperControllerFromLeftTransition;

/*
 * Pushing view controllers with Sliding Super Controller to Left transitions
 */
- (void)pushViewControllerAnimatedWithSlideSuperControllerToRightTransition:(UIViewController *)controller withTransitionDuration:(float)duration;
- (void)pushViewControllerAnimatedWithSlideSuperControllerToRightTransition:(UIViewController *)controller;

/*
 * Poping view controllers with Sliding Super Controller from Left transitions
 */
- (void)popViewControllerWithSlideSuperControllerFromRightTransitionWithDuration:(float)duration;
- (void)popViewControllerWithSlideSuperControllerFromRightTransition;
@end
