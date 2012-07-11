//
//  StorageServicesListVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 7/11/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "StorageServicesListVC.h"

@interface StorageServicesListVC ()

@end

@implementation StorageServicesListVC

@synthesize mainTableView = _mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Storage Services";
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
    [currClient fetchListOfStorageServicesWithCallBack:self withCertPW:certPWField.text];
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

- (NSString *) removeBadCharacters:(NSString *)myStr {
	myStr = [myStr stringByReplacingOccurrencesOfString:@"ï" withString:@""];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"»" withString:@""];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"¿" withString:@""];
    
	return myStr;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *cleanResponseStr = [self removeBadCharacters:[request responseString]];
    NSLog(@"got into requestFinished, result: %@", cleanResponseStr);
    
    // temporary show XML
    [self showGenericAlert:cleanResponseStr withTitle:@"Result XML"];
    
    [self hideLoader:self.view];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"got into didFailReq");
    [self showError:[request error]];
    [self hideLoader:self.view];
}

@end
