//
//  MainViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/14/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()

@end

@implementation CodeViewController

@synthesize workspace;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"CodeViewController initialized");
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

- (IBAction)toggleLeftMenu:(id)sender {
	[workspace toggleLeftSideMenuCompletion:nil];
}


@end
