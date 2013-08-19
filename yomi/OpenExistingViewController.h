//
//  OpenViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/7/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenExistingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(IBAction)close:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
