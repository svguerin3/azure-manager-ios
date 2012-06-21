//
//  HostedServicesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "HostedServicesListVC.h"
#import "WACloudManageClient.h"

@interface HostedServicesListVC ()

@end

@implementation HostedServicesListVC

@synthesize mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Hosted Services";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    servicesArr = [[NSMutableArray alloc] init];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    [self fetchData];
}

- (void) fetchData {
    WACloudManageClient *newClient = [WACloudManageClient manageClientWithCredential:[WAConfig sharedConfiguration].manageAuthCred];
    newClient.delegate = self;
    
    //[self showLoader:self.view];
    [newClient fetchListOfHostedServices];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [servicesArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - WACloudStorageClientDelegate Methods

- (void)storageClient:(WACloudManageClient *)client didFailRequest:(NSURLRequest*)request withError:(NSError *)error {
    NSLog(@"got into didFailReq");
    [self showError:error];
    [self hideLoader:self.view];
}

- (void)storageClient:(WACloudManageClient *)client didFetchHostedServices:(NSArray *)services {
    NSLog(@"got into didFetchHostedServices");
    servicesArr = [services mutableCopy];
    [self.mainTableView reloadData];
    
    [self hideLoader:self.view];
}

@end
