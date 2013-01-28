//
//  CurlUpViewController.m
//  Template-iPhone
//
//  Created by Mohamed Shafraz on 28/01/2013.
//  Copyright (c) 2013 Shafraz Buhary. All rights reserved.
//

#import "CurlUpViewController.h"


@interface CurlUpViewController ()

@end

@implementation CurlUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.navigationController popViewControllerWithCurlDownTransition];
}

@end
