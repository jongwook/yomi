//
//  MainViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/14/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkspaceViewController.h"

@interface CodeViewController : UIViewController

@property (nonatomic, retain) WorkspaceViewController *workspace;

- (IBAction)toggleLeftMenu:(id)sender;

@end
