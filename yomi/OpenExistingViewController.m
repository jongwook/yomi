//
//  OpenViewController.m
//  yomi
//
//  Created by Jong Wook Kim on 8/7/13.
//  Copyright (c) 2013 Jong Wook Kim. All rights reserved.
//

#import "OpenExistingViewController.h"
#import "WorkspaceViewController.h"

#import <ObjectiveGit.h>

@interface Project : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *mdate;
@property (nonatomic, retain) NSString *description;

@end

@implementation Project

@synthesize name;
@synthesize mdate;
@synthesize description;

@end

@interface OpenExistingViewController () {
	NSString *workspace;
	NSMutableArray *projects;
}

@end

@implementation OpenExistingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	workspace = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"workspace"];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	
	NSError *err;
	NSArray *contents = [manager contentsOfDirectoryAtPath:workspace error:&err];
	
	if (err) {
		NSLog(@"Error while getting list of projects");
	}
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"YYYY-MM-dd HH:mm";
	
	projects = [NSMutableArray arrayWithCapacity:contents.count];
		
	for (NSString *content in contents) {
		NSError *err;
		NSString *path = [workspace stringByAppendingPathComponent:content];
		NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
		
		if ([content characterAtIndex:0] == '.') {
			continue;
		}
		
		/* GTRepository *repository = */ [GTRepository repositoryWithURL:url error:&err];
		
		if (err) {
			NSLog(@"Could not open %@ : %@", content, [err localizedDescription]);
			continue;
		}
		
		Project *project = [Project new];
		
		project.name = content;
		project.mdate = [[manager attributesOfItemAtPath:path error:&err] objectForKey:NSFileModificationDate];
		project.description = [NSString stringWithFormat:@"Last modified : %@", [formatter stringFromDate:project.mdate]];
		
		[projects addObject:project];
	}
	
	[projects sortUsingComparator:^(Project *project1, Project *project2){
		return [project2.mdate compare:project1.mdate];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return projects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	Project *project = projects[indexPath.row];
	
	cell.textLabel.text = project.name;
	cell.detailTextLabel.text = project.description;
	cell.imageView.image = [UIImage imageNamed:@"repo32.png"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Project *project = projects[indexPath.row];
	
	
	WorkspaceViewController *container = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkspaceViewController"];
	container.name = project.name;
	container.path = [workspace stringByAppendingPathComponent:project.name];
	
	[self.parentViewController presentModalViewController:container animated:YES];

}

// TODO: delete a existing repo



@end
