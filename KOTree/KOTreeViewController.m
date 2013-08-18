//
//  KOSelectingViewController.m
//  Kodiak
//
//  Created by Adam Horacek on 18.04.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOTree
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOTreeViewController.h"
#import "KOTreeTableViewCell.h"
#import "KOTreeItem.h"

@implementation KOTreeViewController

@synthesize treeTableView;
@synthesize treeItems;

- (NSMutableArray *)listItemsAtPath:(NSString *)path {
	// to be overridden
	return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view.
	
	self.treeItems = [self listItemsAtPath:@"/"];
	
	treeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[treeTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[treeTableView setBackgroundColor:[UIColor colorWithRed:1 green:0.976 blue:0.957 alpha:1] /*#fff9f4*/];
	[treeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[treeTableView setRowHeight:32.0f];
	[treeTableView setDelegate:(id<UITableViewDelegate>)self];
	[treeTableView setDataSource:(id<UITableViewDataSource>)self];
	[self.view addSubview:treeTableView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.treeTableView reloadData];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.treeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	KOTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectingTableViewCell"];
	if (!cell)
		cell = [[KOTreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectingTableViewCell"];
	
	KOTreeItem *treeItem = [self.treeItems objectAtIndex:indexPath.row];
	
	cell.treeItem = treeItem;
	
	if ([treeItem numberOfSubitems])
		[cell.countLabel setText:[NSString stringWithFormat:@"%d", [treeItem numberOfSubitems]]];
	else
		[cell.countLabel setText:@"-"];
	
	[cell.titleTextField setText:[treeItem base]];
	[cell.titleTextField sizeToFit];
	
	[cell setDelegate:(id<KOTreeTableViewCellDelegate>)self];

	[cell setLevel:[treeItem submersionLevel]];
	
	return cell;
}

- (void)selectingItemsToDelete:(KOTreeItem *)selItems saveToArray:(NSMutableArray *)deleteSelectingItems{
	for (KOTreeItem *obj in selItems.ancestorSelectingItems) {
		[self selectingItemsToDelete:obj saveToArray:deleteSelectingItems];
	}
	
	[deleteSelectingItems addObject:selItems];
}

- (NSMutableArray *)removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove {
	NSMutableArray *result = [NSMutableArray array];
	
	for (NSInteger i = 0; i < [treeTableView numberOfRowsInSection:0]; ++i) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		KOTreeTableViewCell *cell = (KOTreeTableViewCell *)[treeTableView cellForRowAtIndexPath:indexPath];

		for (KOTreeItem *tmpTreeItem in treeItemsToRemove) {
			if ([cell.treeItem isEqualToSelectingItem:tmpTreeItem])
				[result addObject:indexPath];
		}
	}	
	
	return result;
}
- (void)tableViewAction:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
	
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self tableViewAction:tableView withIndexPath:indexPath];
	
	KOTreeTableViewCell *cell = (KOTreeTableViewCell *)[treeTableView cellForRowAtIndexPath:indexPath];
	
	NSInteger insertTreeItemIndex = [self.treeItems indexOfObject:cell.treeItem];
	NSMutableArray *insertIndexPaths = [NSMutableArray array];
	NSMutableArray *insertselectingItems = [self listItemsAtPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
	
	NSMutableArray *removeIndexPaths = [NSMutableArray array];
	NSMutableArray *treeItemsToRemove = [NSMutableArray array];
	
	for (KOTreeItem *tmpTreeItem in insertselectingItems) {
		[tmpTreeItem setPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
		[tmpTreeItem setParentSelectingItem:cell.treeItem];
		
		[cell.treeItem.ancestorSelectingItems removeAllObjects];
		[cell.treeItem.ancestorSelectingItems addObjectsFromArray:insertselectingItems];
		
		insertTreeItemIndex++;
		
		BOOL contains = NO;
		
		NSLog(@"Examining %@/%@", tmpTreeItem.path, tmpTreeItem.base);
		for (KOTreeItem *tmp2TreeItem in self.treeItems) {
			if ([tmp2TreeItem isEqualToSelectingItem:tmpTreeItem]) {
				contains = YES;
				
				[self selectingItemsToDelete:tmp2TreeItem saveToArray:treeItemsToRemove];
				
				removeIndexPaths = [self removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove];
				
				NSLog(@"contained : %d, %d", removeIndexPaths.count, treeItemsToRemove.count);
			}
		}
		
		if (!contains) {
			[tmpTreeItem setSubmersionLevel:tmpTreeItem.submersionLevel];
			
			[self.treeItems insertObject:tmpTreeItem atIndex:insertTreeItemIndex];
			
			NSIndexPath *indexPth = [NSIndexPath indexPathForRow:insertTreeItemIndex inSection:0];
			[insertIndexPaths addObject:indexPth];
		}
	}
	
	if ([insertIndexPaths count]) {
		[treeTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	
	for (KOTreeItem *tmp2TreeItem in treeItemsToRemove) {
		[self.treeItems removeObject:tmp2TreeItem];
	}
	
	
	if ([removeIndexPaths count]) {
		[treeTableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
}

#pragma mark - Actions

- (void)iconButtonAction:(KOTreeTableViewCell *)cell treeItem:(KOTreeItem *)tmpTreeItem {

}

#pragma mark - KOTreeTableViewCellDelegate

- (void)treeTableViewCell:(KOTreeTableViewCell *)cell didTapIconWithTreeItem:(KOTreeItem *)tmpTreeItem {
	NSLog(@"didTapIconWithselectingItem.base: %@", [tmpTreeItem base]);
	
	[self iconButtonAction:cell treeItem:tmpTreeItem];
}

@end
