//
//  AnimatedUIViewController.h
//  Template-iPhone
//
//  Created by Mohamed Shafraz on 28/01/2013.
//  Copyright (c) 2013 Shafraz Buhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Akurana/Akurana.h>

typedef enum
{
    CurlUp ,
    CurlDown,
    FlipFromLeft,
    FlipFromRight,
    SlideToLeft,
    SlideToRight,
    SlideSuperFromLeft,
    SlideSuperFromRight
} Transition;

@interface AnimatedUIViewController : UIViewController

@property(nonatomic,assign) Transition popTransition;

@end
