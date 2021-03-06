//
//  GitCloneViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/11/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "GitCloneViewController.h"
#import "WorkspaceViewController.h"

#import <ObjectiveGit.h>

@interface GitCloneViewController () {
	GTRepository *repository;
	volatile int stage;
}

- (void)appendStatus:(NSString *)status replace:(BOOL)replace;

- (void)showProject:(NSString*)name atPath:(NSString *)path;

@end

@implementation GitCloneViewController

@synthesize titleLabel;
@synthesize textView;
@synthesize progressView;

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

-(IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)appendStatus:(NSString *)status replace:(BOOL)replace {
	static NSMutableArray *lines = nil;
	
	// make sure it is running on the main thread
	if (![NSThread isMainThread]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self appendStatus:status replace:replace];
		});
		return;
	}
	
	if (lines == nil) {
		lines = [NSMutableArray array];
	}
	
	if (lines.count > 0 && replace) {
		lines[lines.count-1] = status;
	} else {
		[lines addObject:status];
	}

	NSString *text = [lines componentsJoinedByString:@"\n"];
	[self.textView setText:text];
}

-(void)startCloning:(NSString *)name fromURL:(NSString *)url {
	NSLog(@"Started cloning %@ from %@", name, url);
	
	url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
	NSURL *cloneURL = [NSURL URLWithString:url];
	
	NSString *workspace = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"workspace"];
	NSString *path = [workspace stringByAppendingPathComponent:name];
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	NSURL *workingDirectoryURL = [NSURL fileURLWithPath:path];
	
	static double lastUpdate;
	lastUpdate = CACurrentMediaTime();
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSError *err = nil;
		
		[self appendStatus:[NSString stringWithFormat:@"Cloning into '%@'", name] replace:NO];
		[self appendStatus:@"Connecting ..." replace:NO];
		
		stage = 0;
		
		repository = [GTRepository cloneFromURL:cloneURL
							 toWorkingDirectory:workingDirectoryURL
										 barely:NO
								   withCheckout:YES
										  error:&err
						  transferProgressBlock:^(const git_transfer_progress *progress) {
							  double now = CACurrentMediaTime();
							  BOOL shouldUpdate = NO;
							  if (now - lastUpdate > 0.2) {
								  shouldUpdate = true;
								  lastUpdate = now;
							  }
							  
							  if (shouldUpdate) {
								  dispatch_async(dispatch_get_main_queue(), ^{
									  [self.progressView setProgress:(float)progress->indexed_objects/progress->total_objects];
								  });
							  }
							  
							  NSString *status = [NSString stringWithFormat:@"Transfer progress : %d/%d, %zu KB received", progress->received_objects, progress->total_objects, progress->received_bytes / 1024];
							  
							  if ( stage == 0 ) {
								  stage = 1;
								  
								  [self appendStatus:status replace:NO];
							  } else {
								  if (shouldUpdate) [self appendStatus:status replace:YES];
							  }
							  
							  if ( stage == 1 && progress->received_objects == progress->total_objects ) {
								  stage = 2;
								  [self appendStatus:@"Transfer completed. Preparing to check out ..." replace:NO];
							  }
							  
							  NSLog(@"%@", status);
						  }
						  checkoutProgressBlock:^(NSString *path, NSUInteger completedSteps, NSUInteger totalSteps) {
							  double now = CACurrentMediaTime();
							  BOOL shouldUpdate = NO;
							  if (now - lastUpdate > 0.2) {
								  shouldUpdate = true;
								  lastUpdate = now;
							  }
							  
							  if (shouldUpdate) {
								  dispatch_async(dispatch_get_main_queue(), ^{
									  [self.progressView setProgress:(float)completedSteps/totalSteps];
								  });
							  }
							  
							  NSString *status = [NSString stringWithFormat:@"Checkout progress : %d/%d at %@", completedSteps, totalSteps, path];
							  if ( stage == 2 ) {
								  stage = 3;
								  [self appendStatus:status replace:NO];
							  } else {
								  [self appendStatus:status replace:YES];
							  }
							  
							  NSLog(@"%@", status);
							  
						  }];
		
		if (err) {
			NSString *status = [NSString stringWithFormat:@"Error : %@", err.localizedDescription];
			[self appendStatus:status replace:NO];
			return;
		}
		
		GTReference *head = [repository headReferenceWithError:&err];
		
		if (err) {
			NSString *status = [NSString stringWithFormat:@"Error : %@", err.localizedDescription];
			[self appendStatus:status replace:NO];
			return;
		}
		
		[self appendStatus:[NSString stringWithFormat:@"Cloning completed. head : %@", head.targetSHA] replace:NO];
		
		[self showProject:name atPath:path];
	});
}

- (void)showProject:(NSString*)name atPath:(NSString *)path {
	if (![NSThread isMainThread]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self showProject:name atPath:path];
		});
		return;
	}
	
	WorkspaceViewController *container = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkspaceViewController"];
	container.name = name;
	container.path = path;
	
	[self.parentViewController presentModalViewController:container animated:YES];
}

@end
