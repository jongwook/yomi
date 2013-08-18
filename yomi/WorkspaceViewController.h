//
//  WorkspaceViewController.h
//  yomi
//
//  Created by Jong Wook Kim on 8/16/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"

@interface WorkspaceViewController : MFSideMenuContainerViewController

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *path;

@end
