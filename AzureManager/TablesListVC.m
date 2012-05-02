//
//  TablesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "TablesListVC.h"
#import "AppDelegate.h"
#import "WAResultContinuation.h"
#import "EntitiesListVC.h"

@interface TablesListVC ()

@end

@implementation TablesListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"List of Tables";
        _fetchedResults = NO;
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
	self.mainTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (storageClient) {
        storageClient.delegate = nil;
	}

	storageClient = [WACloudStorageClient storageClientWithCredential:appDelegate.authenticationCredential];
	storageClient.delegate = self;
	
    if (self.localStorageList.count == 0) {
        [self fetchData];
    }
}

- (void)fetchData {
    [self showLoader:self.view];
    [storageClient fetchTablesWithContinuation:self.resultContinuation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
    self.localStorageList = nil;
    self.resultContinuation = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    cell.textLabel.numberOfLines = 0;
	
    cell.textLabel.text = [NSString stringWithFormat:@"%i. %@", indexPath.row+1, [self.localStorageList objectAtIndex:indexPath.row]];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EntitiesListVC *aController = [[EntitiesListVC alloc] initWithNibName:@"EntitiesList" bundle:nil];
    aController.tableName = [self.localStorageList objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:aController animated:YES];
    [self.mainTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.localStorageList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

#pragma mark - WACloudStorageClientDelegate Methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchTables:(NSArray *)tables withResultContinuation:(WAResultContinuation *)resultContinuation
{
    if (resultContinuation.nextTableKey == nil && !_fetchedResults) {
        [self.localStorageList removeAllObjects];
    } else {
        _fetchedResults = YES;
    }

    self.resultContinuation = resultContinuation;
    [self.localStorageList addObjectsFromArray:tables];
	[self.mainTableView reloadData];
    
    [self hideLoader:self.view];
}


@end
