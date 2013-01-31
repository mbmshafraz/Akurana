//
//  AnimatedUIViewController.m
//  Template-iPhone
//
//  Created by Mohamed Shafraz on 28/01/2013.
//  Copyright (c) 2013 Shafraz Buhary. All rights reserved.
//

#import "AnimatedUIViewController.h"

@interface AnimatedUIViewController ()

@end

@implementation AnimatedUIViewController



- (id)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = backButton;
        self.view.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)back:(id)sender
{
    switch (_popTransition) {
        case CurlUp:
            [self.navigationController popViewControllerWithCurlUpTransition];
            break;
        case CurlDown:
            [self.navigationController popViewControllerWithCurlDownTransition];
            break;
        case FlipFromLeft:
            [self.navigationController popViewControllerWithFlipFromLeftTransition];
            break;
        case FlipFromRight:
            [self.navigationController popViewControllerWithFlipFromRightTransition];
            break;
        case SlideToLeft:
            [self.navigationController popViewControllerWithSlideToLeftTransition];
            break;
        case SlideToRight:
            [self.navigationController popViewControllerWithSlideToRightTransition];
            break;
        case SlideSuperFromLeft:
            [self.navigationController popViewControllerWithSlideSuperControllerFromLeftTransition];
            break;
        case SlideSuperFromRight:
            [self.navigationController popViewControllerWithSlideSuperControllerFromRightTransition];
            break;
        default:
            break;
    }
}

@end
