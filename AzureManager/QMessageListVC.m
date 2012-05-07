//
//  QMessageListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "QMessageListVC.h"
#import "WAResultContinuation.h"
#import "WABlob.h"
#import "WAQueue.h"
#import "EntityTableViewCell.h"
#import "WAQueueMessage.h"

@interface QMessageListVC ()

@end

@implementation QMessageListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;
@synthesize currQueue = _currQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Message List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    storageClient = nil;
    _localStorageList = [[NSMutableArray alloc] initWithCapacity:MAXNUMROWS_QMESSAGES];
    
    // Tableview init code
    self.mainTableView.dataSource = self;
	self.mainTableView.delegate = self;
	((UIScrollView *)self.mainTableView).delegate = self;
	self.mainTableView.scrollEnabled = YES;
	self.mainTableView.showsVerticalScrollIndicator = YES;
	self.mainTableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
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

- (void)fetchData {
    [self showLoader:self.view];
    
    [storageClient fetchQueueMessages:self.currQueue.queueName fetchCount:MAXNUMROWS_QMESSAGES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger count = fetchCount;
    NSUInteger localCount = self.localStorageList.count;
    
    if (count >= MAXNUMROWS_QMESSAGES &&
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
    
    if (indexPath.row != self.localStorageList.count) {
        if (cell == nil) {
            cell = [[EntityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        WAQueueMessage *queueMessage = [self.localStorageList objectAtIndex:indexPath.row];
        [cell setKeysAndObjects:queueMessage, nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    if (indexPath.row == self.localStorageList.count) {   
        if (fetchCount == MAXNUMROWS_QMESSAGES) {
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int count = 0;
	
    if (indexPath.row >= self.localStorageList.count) {
        return 40;  
    } else {
		count = 7;
	}
	
	return 12 + count * 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.mainTableView reloadData];
    
}

#pragma mark - WACloudStorageClientDelegate Methods

- (void)storageClient:(WACloudStorageClient *)client didFailRequest:request withError:error
{
	[self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudStorageClient *)client didFetchQueueMessages:(NSArray *)queueMessages
{
    [self.localStorageList addObjectsFromArray:queueMessages];
	[self.mainTableView reloadData];
    [self hideLoader:self.view];    
}


@end