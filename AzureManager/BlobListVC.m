//
//  BlobListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "BlobListVC.h"
#import "WAResultContinuation.h"
#import "WABlob.h"
#import "BlobImageViewVC.h"

@interface BlobListVC ()

@end

@implementation BlobListVC

@synthesize resultContinuation = _resultContinuation;
@synthesize localStorageList = _localStorageList;
@synthesize mainTableView = _mainTableView;
@synthesize currContainer = _currContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Blob List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    storageClient = nil;
    _localStorageList = [[NSMutableArray alloc] initWithCapacity:MAXNUMROWS_BLOBS];
    
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

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(infoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void) infoBtnPressed {
    NSString *infoAlertStr = [NSString stringWithFormat:@"Total # of Blobs in this Container: %i\n\nTotal # of Images in this group of Blobs: %i", [self.localStorageList count], totalImgCount];
    [self showGenericAlert:infoAlertStr withTitle:@"Info"];
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

    [storageClient fetchBlobsWithContinuation:self.currContainer resultContinuation:self.resultContinuation maxResult:MAXNUMROWS_BLOBS];
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
	
    WABlob *currBlob = [self.localStorageList objectAtIndex:indexPath.row];
    cell.textLabel.text = currBlob.name;

    if (downloadedImgCount <= totalImgCount) {
        NSString *contentType = [currBlob.properties objectForKey:WABlobPropertyKeyContentType];
        if ([contentType hasPrefix:@"image"]) {
            [storageClient fetchBlobData:currBlob withCompletionHandler:^(NSData *imgData, NSError *error) {
                if (!error) {
                    cell.imageView.image = [UIImage imageWithData:imgData];

                    downloadedImgCount++;
                    if (downloadedImgCount == totalImgCount) { // done downloading, need to refresh
                        [self.mainTableView reloadData];
                    }
                } else {
                    [self showError:error];
                }
            }];
        }
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BlobImageViewVC *aController = [[BlobImageViewVC alloc] initWithNibName:@"BlobImageView" bundle:nil];
    aController.currBlob = [self.localStorageList objectAtIndex:indexPath.row];
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

- (void)storageClient:(WACloudStorageClient *)client didFetchBlobs:(NSArray *)blobs inContainer:(WABlobContainer *)container withResultContinuation:(WAResultContinuation *)resultContinuation
{
    self.resultContinuation = resultContinuation;
    [self.localStorageList addObjectsFromArray:blobs];
	[self.mainTableView reloadData];
    
    for (WABlob *currBlob in self.localStorageList) {
        NSString *contentType = [currBlob.properties objectForKey:WABlobPropertyKeyContentType];
        if ([contentType hasPrefix:@"image"]) {
            totalImgCount++;
        }
    }
    NSLog(@"totalImgCount: %i", totalImgCount);
    
    [self hideLoader:self.view];
}


@end