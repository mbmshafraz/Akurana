//
//  RootViewController.m
//  Template-iPhone
//
//  Created by Mohamed Shafraz on 04/01/2013.
//  Copyright (c) 2013 Shafraz Buhary. All rights reserved.
//

#import "RootViewController.h"
#import "AnimatedUIViewController.h"
//#import "CurlUpViewController.h"
//#import "FlipViewController.h"
//#import "RightSlideViewController.h"
//#import "LeftSlideViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"Curl Up Animation";
            break;
        case 1:
            cell.textLabel.text = @"Curl Down Animation";
            break;
        case 2:
            cell.textLabel.text = @"Flip Animation";
            break;
        case 3:
            cell.textLabel.text = @"Slid from right Animation";
            break;
        case 4:
            cell.textLabel.text = @"Slid from left Animation";
            break;
        case 5:
            cell.textLabel.text = @"Slid Super to left Animation";
            break;
        case 6:
            cell.textLabel.text = @"Slid Super to right Animation";
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([indexPath row]) {
        case 0:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = CurlDown;
            [self.navigationController pushViewControllerAnimatedWithCurlUpTransition:viewController];
            break;
        }
        case 1:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = CurlUp;
            [self.navigationController pushViewControllerAnimatedWithCurlDownTransition:viewController];
            break;
        }
        case 2:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = FlipFromRight;
            [self.navigationController pushViewControllerAnimatedWithFlipFromLeftTransition:viewController];
            break;
        }
        case 3:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = SlideToRight;
            [self.navigationController pushViewControllerAnimatedWithSlideFromRightTransition:viewController];
            break;
        }
        case 4:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = SlideToLeft;
            [self.navigationController pushViewControllerAnimatedWithSlideFromLeftTransition:viewController];
            break;
        }
        case 5:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = SlideSuperFromLeft;
            [self.navigationController pushViewControllerAnimatedWithSlideSuperControllerToLeftTransition:viewController];
            break;
        }
        case 6:
        {
            AnimatedUIViewController *viewController = [AnimatedUIViewController new];
            viewController.popTransition = SlideSuperFromRight;
            [self.navigationController pushViewControllerAnimatedWithSlideSuperControllerToRightTransition:viewController];
            break;
        }
        default:
            break;

    }
}

@end
