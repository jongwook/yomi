//
//  WorkspaceViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/16/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "WorkspaceViewController.h"
#import "LeftMenuViewController.h"
#import "CodeViewController.h"

@interface WorkspaceViewController ()

@end

@implementation WorkspaceViewController

@synthesize name;
@synthesize path;

-(id)init {
	[self setDefaultSettings];
	NSLog(@"WorkspaceViewController.init");
	
	// temp
	NSString *workspace = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"workspace"];
	name = @"vbap";
	path = [workspace stringByAppendingPathComponent:@"vbap"];
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return [self init];
}

- (id)initWithCoder:(NSCoder *)coder {
	NSLog(@"WorkspaceViewController.initWithCoder ; %@", coder);
	self = [super initWithCoder:coder];
	return [self init];
}

- (void)setDefaultSettings {
	[super setDefaultSettings];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	self.leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
	self.centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"CodeViewController"];
	((LeftMenuViewController *)self.leftMenuViewController).workspace = self;
	((CodeViewController *)self.centerViewController).workspace = self;
	self.rightMenuViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openFile:(NSString *)localpath {
	[self.centerViewController openFile:[NSString stringWithFormat:@"/%@%@", name, localpath]];
}

@end
