//
//  SearchViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/5/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SearchGithubViewController.h"
#import "CenterViewController.h"
#import "GitCloneViewController.h"
#import "GTObject.h"

@interface SearchGithubViewController () {
	NSString *lastKeyword;
	NSURLConnection *lastConnection;
	NSArray *repositories;
}

- (void)search:(NSString *)keyword;

@end

@implementation SearchGithubViewController

@synthesize searchField;
@synthesize countLabel;
@synthesize activityIndicatorView;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"SearchViewController - viewDidLoad");
	
	[self.searchField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textChanged:(id)sender
{
	NSLog(@"SearchViewController - textChanged : %@", self.searchField.text);
	lastKeyword = self.searchField.text;
	[self performSelector:@selector(search:) withObject:lastKeyword afterDelay:0.5];
	
	[self.activityIndicatorView startAnimating];
	[self.countLabel setHidden:YES];
}

- (void)search:(NSString *)keyword {
	if (keyword != NULL && ![keyword isEqualToString:lastKeyword]) {
		NSLog(@"Discarding old keyword %@", keyword);
		return;
	}
	if (keyword == NULL || keyword.length == 0) {
		[self.activityIndicatorView stopAnimating];
		[self.countLabel setHidden:YES];
		return;
	}
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", keyword]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	[request setValue:@"application/vnd.github.preview" forHTTPHeaderField:@"Accept"];
	lastConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[lastConnection start];
	
	NSLog(@"Searching for : %@", keyword);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (connection != lastConnection) {
		NSLog(@"Discarding old connection %@", connection);
		return;
	}
	
	
	NSError *error;
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

	NSInteger count = [(NSNumber *)[result objectForKey:@"total_count"] intValue];

	NSLog(@"Received : %d repositories", count);

	[self.countLabel setText:[NSString stringWithFormat:@"%d found", count]];
	[self.countLabel setHidden:NO];
	
	repositories = (NSArray *)[result objectForKey:@"items"];
	[self.tableView reloadData];
	
	[self.activityIndicatorView stopAnimating];
}

-(IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [repositories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	NSDictionary *item = (NSDictionary *)repositories[indexPath.row];
	
	id description = item[@"description"];
	id cloneURL = item[@"clone_url"] ;
	
	cell.textLabel.text = [description isKindOfClass:[NSString class]] ? description : @"";
	cell.detailTextLabel.text = [cloneURL isKindOfClass:[NSString class]] ? cloneURL : @"";
	cell.imageView.image = [UIImage imageNamed:@"repo32.png"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *item = (NSDictionary *)repositories[indexPath.row];

	NSLog(@"Starting to clone %@", item[@"clone_url"]);
	
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
								  [gcvc startCloning:item[@"name"] fromURL:item[@"clone_url"]];
							  }];
	
}

@end
