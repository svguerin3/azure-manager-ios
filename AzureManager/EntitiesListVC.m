//
//  EntitiesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "EntitiesListVC.h"
#import "WAResultContinuation.h"
#import "WATableFetchRequest.h"
#import "WATableEntity.h"
#import "EntityTableViewCell.h"
#import "EntityDetailVC.h"

@interface EntitiesListVC ()

@end

@implementation EntitiesListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;
@synthesize tableName = _tableName;
@synthesize queryBtn = _queryBtn;

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
    
    self.title = self.tableName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	if (storageClient) {
        storageClient.delegate = nil;
	}
    
	storageClient = [WACloudStorageClient storageClientWithCredential:[WAConfig sharedConfiguration].authenticationCredential];
	storageClient.delegate = self;
	
    if (self.localStorageList.count == 0) {
        [self fetchData];
    }
}

- (void) infoBtnPressed {
    
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
    NSUInteger count = fetchCount;
    NSUInteger localCount = self.localStorageList.count;
    
    if (count >= MAXNUMROWS_ENTITIES &&
        self.resultContinuation.nextPartitionKey != nil &&
        self.resultContinuation.nextRowKey != nil) {
        localCount += 1;
    }
    
    return localCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"Cell2";
    EntityTableViewCell *cell = (EntityTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (indexPath.row != self.localStorageList.count) {
        WATableEntity *entity = [self.localStorageList objectAtIndex:indexPath.row];
        if (objViewSelected) {
            UITableViewCell *objCell = [tableView dequeueReusableCellWithIdentifier:@"ObjCell"];
            if (objCell == nil) {
                objCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ObjCell"];
            }
            objCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            objCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            objCell.textLabel.text = [NSString stringWithFormat:@"%@", [entity description]];
            objCell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            objCell.textLabel.numberOfLines = 0;
            return objCell;
        } else {
            if (cell == nil) {
                cell = [[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setKeysAndObjects:@"PartitionKey", [entity partitionKey], @"RowKey", [entity rowKey], entity, nil];
        }
    } else if (indexPath.row == self.localStorageList.count) {   
        if (fetchCount == MAXNUMROWS_ENTITIES) {
            UITableViewCell *loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore"];
            if (loadMoreCell == nil) {
                loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMore"];
            }
            
            UILabel *loadMore =[[UILabel alloc] initWithFrame:CGRectMake(0,0,362,40)];
            loadMore.textColor = [UIColor blackColor];
            loadMore.highlightedTextColor = [UIColor darkGrayColor];
            loadMore.backgroundColor = [UIColor clearColor];
            loadMore.textAlignment = UITextAlignmentCenter;
            loadMore.font = [UIFont boldSystemFontOfSize:20];
            loadMore.text = @"Show more results...";
            [loadMoreCell addSubview:loadMore];
            return loadMoreCell;
        }
    }
    
	return cell;
}

- (IBAction)viewTypeFilterBtnPressed:(id)sender {
    UISegmentedControl *currControl = (UISegmentedControl *)sender;
    
    if (currControl.selectedSegmentIndex == listViewIndex) {
        objViewSelected = NO;
    } else if (currControl.selectedSegmentIndex == objViewIndex) {
        objViewSelected = YES;
    }
    [self.mainTableView reloadData];
}

- (IBAction)queryBtnPressed {
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int count = 0;
	
    if (indexPath.row >= self.localStorageList.count) {
        return 40;  
    } else if (objViewSelected) {
        WATableEntity *entity = [self.localStorageList objectAtIndex:indexPath.row];
        NSString *objDataStr = [entity description];
        CGSize labelSize = CGSizeMake(200.0, 20.0);
        if ([objDataStr length] > 0) {
            labelSize = [objDataStr sizeWithFont: [UIFont boldSystemFontOfSize: 12.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
        }
        return labelSize.height;
    } else {
		//WATableEntity *entity = [self.localStorageList objectAtIndex:indexPath.row];
		//count = entity.keys.count + 2;
        count = 3;
        return 12 + count * 25;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.localStorageList.count) {
        [tableView beginUpdates];
        fetchCount--;
        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewScrollPositionBottom];
        [tableView endUpdates];
        [self fetchData];
    } else {
        WATableEntity *currEntity = [self.localStorageList objectAtIndex:indexPath.row];
        if ([currEntity.keys count] > 0) {
            EntityDetailVC *aController = [[EntityDetailVC alloc] initWithNibName:@"EntityDetail" bundle:nil];
            aController.currEntity = currEntity;
            [[self navigationController] pushViewController:aController animated:YES];
        } else {
            [self showGenericAlert:@"No properties found for this entity" withTitle:@""];
        }
    }
    [tableView reloadData];
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
    self.queryBtn = nil;
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
