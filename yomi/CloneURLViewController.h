//
//  URLViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/7/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloneURLViewController : UIViewController <UITextFieldDelegate>

-(IBAction)close:(id)sender;
-(IBAction)clone:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *urlField;

@end
