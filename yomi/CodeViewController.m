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

@synthesize webView;
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

- (void)openFile:(NSString *)path {
	NSLog(@"Loading code file at %@", path);
	NSString *url = [NSString stringWithFormat:@"http://localhost:8192/web/prism.html?%@", path];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)openMarkdown:(NSString *)path {
	NSLog(@"Loading markdown page at %@", path);
	NSString *url = [NSString stringWithFormat:@"http://localhost:8192/web/markdown.html?%@", path];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (IBAction)close:(id)sender {
	[self.workspace dismissModalViewControllerAnimated:YES];
}

@end
