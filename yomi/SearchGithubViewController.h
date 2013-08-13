//
//  SearchViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/5/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGithubViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource>

-(IBAction)textChanged:(id)sender;
-(IBAction)close:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
