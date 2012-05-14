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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    [self fetchData];
}

- (void)fetchData {
    [self showLoader:self.view];
    
    if (storageClient) {
        storageClient.delegate = nil;
	}
    
	storageClient = [WACloudStorageClient storageClientWithCredential:[WAConfig sharedConfiguration].authenticationCredential];
	storageClient.delegate = self;
    
    [storageClient fetchTables];
    [storageClient fetchBlobContainers];
    [storageClient fetchQueues];
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
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (indexPath.section == tablesSectionInd) {
            cell.textLabel.text = [NSString stringWithFormat:@"Total # of Tables: %i", countTables];
        } else if (indexPath.section == blobsSectionInd) {
            cell.textLabel.text = [NSString stringWithFormat:@"Total # of Blob Containers: %i", countBlobContainers];
        } else if (indexPath.section == queuesSectionInd) {
            cell.textLabel.text = [NSString stringWithFormat:@"Total # of Queues: %i", countQueues];
        } 
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) { // ignore taps to the stats row
        return;
    }
    
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
        return 50;
    }
    return 40;
}

- (void) checkToRemoveSpinner {
    if (fetchedBlobs && fetchedTables && fetchedQueues) {
        [self.mainTableView reloadData];
        [self hideLoader:self.view];
    }
}

#pragma mark - WACloudStorageClientDelegate Methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchTables:(NSArray *)tables {
    countTables = [tables count];
    fetchedTables = YES;
    [self checkToRemoveSpinner];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchBlobContainers:(NSArray *)containers
{
    countBlobContainers = [containers count];
    fetchedBlobs = YES;
    [self checkToRemoveSpinner];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchQueues:(NSArray *)queues 
{
    countQueues = [queues count];
    fetchedQueues = YES;
    [self checkToRemoveSpinner];
}

@end
