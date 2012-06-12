//
//  ContainerListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "ContainerListVC.h"
#import "WAResultContinuation.h"
#import "WABlobContainer.h"
#import "BlobListVC.h"

@interface ContainerListVC ()

@end

@implementation ContainerListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;
@synthesize tableSearchData = _tableSearchData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Container List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    storageClient = nil;
    _localStorageList = [[NSMutableArray alloc] initWithCapacity:MAXNUMROWS_TABLES];
    
    // Tableview init code
    self.mainTableView.dataSource = self;
	self.mainTableView.delegate = self;
	((UIScrollView *)self.mainTableView).delegate = self;
	self.mainTableView.scrollEnabled = YES;
	self.mainTableView.showsVerticalScrollIndicator = YES;
	self.mainTableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(infoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    self.tableSearchData = [[NSMutableArray alloc] init];
}

- (void) infoBtnPressed {
    NSString *infoAlertStr = [NSString stringWithFormat:@"Total # of Blob Containers: %i", [self.localStorageList count]];
    [self showGenericAlert:infoAlertStr withTitle:@"Info"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	if (storageClient) {
        storageClient.delegate = nil;
	}
    
	storageClient = [WACloudStorageClient storageClientWithCredential:[WAConfig sharedConfiguration].storageAuthCred];
	storageClient.delegate = self;
	
    if (self.localStorageList.count == 0) {
        [self fetchData];
    }
}

- (void)fetchData {
    [self showLoader:self.view];
    //[storageClient fetchBlobContainersWithContinuation:self.resultContinuation maxResult:MAXNUMROWS_CONTAINERS];
    [storageClient fetchBlobContainers];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self filterTheList:@""];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
	
    [self filterTheList:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterTheList:searchBar.text];
}

- (void) filterTheList:(NSString *)filterText {
    [self.tableSearchData removeAllObjects];
    
    if ([filterText length] > 0) {
        for (WABlobContainer *currContainer in self.localStorageList) {
            NSRange range = [[currContainer.name uppercaseString] rangeOfString:[filterText uppercaseString]];
            if (range.location != NSNotFound) {
                [self.tableSearchData addObject:currContainer];
            }  
        }
    } else { // filter empty
        [self.tableSearchData addObjectsFromArray:self.localStorageList];
    }
    [self.mainTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
    self.localStorageList = nil;
    self.resultContinuation = nil;
    self.tableSearchData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    cell.textLabel.numberOfLines = 0;
	
    WABlobContainer *currContainer = [self.localStorageList objectAtIndex:indexPath.row];
	cell.textLabel.text = currContainer.name;
    
    [storageClient fetchBlobs:currContainer withCompletionHandler:^(NSArray *blobs, NSError *error) {
        if (!error) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Blobs: %i", [blobs count] ];
        } else {
            [self showError:error];
        }
    }];
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WABlobContainer *currContainer = [self.localStorageList objectAtIndex:indexPath.row];
    
    [self showLoader:self.view];
    [storageClient fetchBlobs:currContainer withCompletionHandler:^(NSArray *blobs, NSError *error) {
        if ([blobs count] > 0) {
            BlobListVC *aController = [[BlobListVC alloc] initWithNibName:@"BlobList" bundle:nil];
            aController.currContainer = [self.localStorageList objectAtIndex:indexPath.row];
            [[self navigationController] pushViewController:aController animated:YES];
        } else {
            [self showGenericAlert:@"No Blobs found for this Container" withTitle:@""];
        }
        [self hideLoader:self.view];
    }];
    
    [self.mainTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableSearchData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

#pragma mark - WACloudStorageClientDelegate Methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchBlobContainers:(NSArray *)containers
{
    //self.resultContinuation = resultContinuation;
    [self.localStorageList addObjectsFromArray:containers];
    [self.tableSearchData addObjectsFromArray:containers];
	[self.mainTableView reloadData];
    [self hideLoader:self.view];
}


@end
