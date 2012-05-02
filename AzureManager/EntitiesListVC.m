//
//  EntitiesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "EntitiesListVC.h"
#import "AppDelegate.h"
#import "WAResultContinuation.h"
#import "WATableFetchRequest.h"
#import "WATableEntity.h"

@interface EntitiesListVC ()

@end

@implementation EntitiesListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;
@synthesize tableName = _tableName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Entities List";
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
    WATableFetchRequest *fetchRequest = [WATableFetchRequest fetchRequestForTable:self.tableName];
    fetchRequest.resultContinuation = self.resultContinuation;
    fetchRequest.topRows = MAXNUMROWS_ENTITIES;
    [storageClient fetchEntitiesWithContinuation:fetchRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.localStorageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    cell.textLabel.numberOfLines = 0;
	
    WATableEntity *currEntity = [self.localStorageList objectAtIndex:indexPath.row];
	cell.textLabel.text = currEntity.description;
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    self.tableName = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CloudStorageClientDelegate methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchEntities:(NSArray *)entities fromTableNamed:(NSString *)tableName withResultContinuation:(WAResultContinuation *)resultContinuation
{
    self.resultContinuation = resultContinuation;
    [self.localStorageList addObjectsFromArray:entities];    
	[self.mainTableView reloadData];
    
    [self hideLoader:self.view];
}

@end
