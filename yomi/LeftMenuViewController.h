//
//  LeftMenuViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/16/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KOTreeViewController.h"
#import "WorkspaceViewController.h"

@interface LeftMenuViewController : KOTreeViewController <KOTreeViewControllerDelegate>

@property (nonatomic, retain) WorkspaceViewController *workspace;


@end
