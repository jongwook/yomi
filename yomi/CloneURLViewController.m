//
//  URLViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/7/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "CloneURLViewController.h"
#import "GitCloneViewController.h"

@interface CloneURLViewController ()

@end

@implementation CloneURLViewController

@synthesize urlField;

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
	
	[self.urlField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)clone:(id)sender	{
	
	NSString *url = urlField.text;
	
	NSError *err;
	
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^/]+" options:0 error:&err];
	
	NSString *tempurl = [url stringByReplacingOccurrencesOfString:@".git" withString:@""];
	NSArray *matches = [regex matchesInString:tempurl options:0 range:NSMakeRange(0, tempurl.length)];
	NSString *name = [tempurl substringWithRange:[matches[matches.count-1] range]];
	
	NSLog(@"Starting to clone %@", url);
	
	UIViewController *parent = self.parentViewController;
	GitCloneViewController *gcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GitCloneViewController"];
	
	[parent addChildViewController:gcvc];
	[self willMoveToParentViewController:nil];
	
	float pageWidth = parent.view.frame.size.width;
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	
	[gcvc.view setFrame:CGRectMake(pageWidth, 0.0, width, height)];
	
	[parent transitionFromViewController:self
						toViewController:gcvc
								duration:0.3
								 options:UIViewAnimationOptionCurveEaseInOut
							  animations:^{
								  [gcvc.view setFrame:self.view.frame];
								  [self.view setFrame:CGRectMake(-pageWidth, 0.0, width, height)];
							  }
							  completion:^(BOOL finished){
								  [self removeFromParentViewController];
								  [gcvc didMoveToParentViewController:parent];
								  [gcvc startCloning:name fromURL:url];
							  }];
	
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self clone:textField];
	return YES;
}

@end
