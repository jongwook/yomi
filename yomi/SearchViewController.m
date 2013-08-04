//
//  SearchViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/5/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () {
	NSString *lastKeyword;
	NSURLConnection *lastConnection;
}

- (void)search:(NSString *)keyword;

@end

@implementation SearchViewController

@synthesize searchField;
@synthesize activityIndicatorView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"SearchViewController - viewDidLoad");
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
	if (![keyword isEqualToString:lastKeyword]) {
		NSLog(@"Discarding old keyword %@", keyword);
		return;
	}
	if (keyword.length == 0) {
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
	
	NSLog(@"didReceiveData : %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	NSError *error;
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

	NSInteger count = [(NSNumber *)[result objectForKey:@"total_count"] intValue];
	[self.countLabel setText:[NSString stringWithFormat:@"%d found", count]];
	[self.countLabel setHidden:NO];
	
	// TODO: display result
	
	[self.activityIndicatorView stopAnimating];
}


@end
