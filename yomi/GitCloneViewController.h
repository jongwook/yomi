//
//  GitCloneViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/11/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GitCloneViewController : UIViewController

-(IBAction)close:(id)sender;

-(void)startCloning:(NSString *)name fromURL:(NSString *)url;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@end
