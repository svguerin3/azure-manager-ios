//
//  HostedServicesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
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
    
    currClient = [WACloudManageClient manageClientWithCredential:[WAConfig sharedConfiguration].manageAuthCred];
    
    [self showCertPWAlert];
}

- (void) showCertPWAlert {
    certPWAlert = [[UIAlertView alloc] initWithTitle:@"Certificate Password:" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    certPWField = [[UITextField alloc] initWithFrame:CGRectMake(25, 43, 236, 28)];
    certPWField.borderStyle = UITextBorderStyleRoundedRect;
    certPWField.font = [UIFont systemFontOfSize:14.0];
    certPWField.autocorrectionType = UITextAutocorrectionTypeNo;
    certPWField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    certPWField.returnKeyType = UIReturnKeyDone;
    certPWField.delegate = self;
    certPWField.clearsOnBeginEditing = NO;
    certPWField.secureTextEntry = YES;
    
    [certPWAlert addSubview:certPWField];
    [certPWAlert show];
    
    [certPWField becomeFirstResponder];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([certPWField.text length] > 0) {
            [self fetchData];
        } else {
            [self showCertPWAlert];
        }
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ([certPWField.text length] > 0) {
        [textField resignFirstResponder];
        [self fetchData];
    }  
    
    return YES;
}

- (void) fetchData {
    currClient.delegate = self;
    
    [self showLoader:self.view];
    [currClient fetchListOfHostedServicesWithCallBack:self withCertPW:certPWField.text];
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
