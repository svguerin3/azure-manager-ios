//
//  StorageSelectionVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "StorageSelectionVC.h"
#import "TablesListVC.h"
#import "ContainerListVC.h"
#import "QueueListVC.h"

@interface StorageSelectionVC ()

@end

@implementation StorageSelectionVC

@synthesize mainTableView = _mainTableView;
@synthesize localStorageList;
@synthesize resultContinuation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Storage Browser";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Tableview init code
    self.mainTableView.dataSource = self;
	self.mainTableView.delegate = self;
	((UIScrollView *)self.mainTableView).delegate = self;
	self.mainTableView.scrollEnabled = NO;
	self.mainTableView.backgroundColor = [UIColor clearColor];
}

- (void)fetchData {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == tablesSectionInd) {
            cell.textLabel.text = @"Tables";
        } else if (indexPath.section == blobsSectionInd) {
            cell.textLabel.text = @"Blobs";
        } else if (indexPath.section == queuesSectionInd) {
            cell.textLabel.text = @"Queues";
        }
    } else if (indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"stats";
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == tablesSectionInd) {
        TablesListVC *aController = [[TablesListVC alloc] initWithNibName:@"TablesList" bundle:nil];
        [[self navigationController] pushViewController:aController animated:YES];
    } else if (indexPath.section == blobsSectionInd) {
        ContainerListVC *aController = [[ContainerListVC alloc] initWithNibName:@"ContainerList" bundle:nil];
        [[self navigationController] pushViewController:aController animated:YES];
    } else if (indexPath.section == queuesSectionInd) {
        QueueListVC *aController = [[QueueListVC alloc] initWithNibName:@"QueueList" bundle:nil];
        [[self navigationController] pushViewController:aController animated:YES];
    }
    
    [tableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 75;
    }
    return 40;
}

@end
