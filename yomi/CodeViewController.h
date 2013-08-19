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

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) WorkspaceViewController *workspace;

- (void)openFile:(NSString *)path;
- (void)openMarkdown:(NSString *)path;

- (IBAction)close:(id)sender;

@end
