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

@end
