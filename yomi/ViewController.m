//
//  ViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/4/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"ViewController - viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		NSLog(@"willRotateToInterfaceOrientation - portrait");
		[self.topConstraint setConstant:50];
		[self.bottomConstraint setConstant:300];
	} else {
		NSLog(@"willRotateToInterfaceOrientation - landscape");
		[self.topConstraint setConstant:0];
		[self.bottomConstraint setConstant:350];
	}
}


@end
