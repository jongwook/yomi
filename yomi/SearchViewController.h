//
//  SearchViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/5/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <NSURLConnectionDataDelegate>

-(IBAction)textChanged:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
