//
//  LeftMenuViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/16/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "KOTreeItem.h"

@interface LeftMenuViewController () {
	// path -> item
	NSMutableDictionary *items;
	NSString *basepath;
}

@end

@implementation LeftMenuViewController

@synthesize workspace;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"LeftViewController initialized");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	basepath = self.workspace.path;
	
	items = [NSMutableDictionary dictionary];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		self.treeItems = [self itemsAtPath:@"/" level:0 parent:nil];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.treeTableView reloadData];
		});
	});
}

- (NSMutableArray *)itemsAtPath:(NSString *)path level:(int)level parent:(KOTreeItem *)parent {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *realpath = [basepath stringByAppendingPathComponent:path];
	NSArray *contents = [manager contentsOfDirectoryAtPath:realpath error:nil];
	
	KOTreeItem *subitems[contents.count];
	int count = 0;
	for (NSString *name in contents) {
		if ([name isEqualToString:@".git"] || (name.length >= 4 && [[name substringToIndex:4] isEqualToString:@".git/"])) continue;
		
		NSString *subpath = [path stringByAppendingPathComponent:name];
		
		KOTreeItem *item = [KOTreeItem new];
		item.base = name;
		item.path = path;
		item.submersionLevel = level;
		item.parentSelectingItem = parent;
		item.ancestorSelectingItems = [self itemsAtPath:subpath level:level+1 parent:item];
		item.numberOfSubitems = item.ancestorSelectingItems.count;
		
		items[subpath] = item.ancestorSelectingItems;
		
		subitems[count++] = item;
	}
	
	return [NSMutableArray arrayWithObjects:subitems count:count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KOTreeViewController

- (NSMutableArray *)listItemsAtPath:(NSString *)path {
	return [NSMutableArray arrayWithArray:items[path]];
}



@end
