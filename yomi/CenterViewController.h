//
//  CenterViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/7/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, retain) IBOutlet UIViewController *containedViewController;

@end
