//
//  BlobMonitoringVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/21/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "BlobMonitoringVC.h"
#import "WACloudManageClient.h"
#import "TBXML.h"

@interface BlobMonitoringVC ()

@end

@implementation BlobMonitoringVC

@synthesize mainTableView = _mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Blob Monitoring";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // init the ivars
    
    CGRect inputFieldRect = CGRectMake(250, 10, 50, 40);
    CGRect switchFieldRect = CGRectMake(228, 9, 70, 25);
    
    loggingRetentionDaysField = [[UITextField alloc] initWithFrame:inputFieldRect];
    metricsRetentionDaysField = [[UITextField alloc] initWithFrame:inputFieldRect];

    mySwitchDelete = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchRead = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchWrite = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchLoggingRetentionEnabled = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchMetricsEnabled = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchIncludeAPIs = [[UISwitch alloc] initWithFrame:switchFieldRect];
    mySwitchMetricsRetentionEnabled = [[UISwitch alloc] initWithFrame:switchFieldRect];
    
    /*[mySwitchDelete addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchRead addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchWrite addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchLoggingRetentionEnabled addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchMetricsEnabled addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchIncludeAPIs addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
    [mySwitchMetricsRetentionEnabled addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged]; */
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] 
                                initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                target:self action:@selector(saveBtnPressed)] ;
	self.navigationItem.rightBarButtonItem = saveBtn;  
    
    [self fetchData];
}

- (void) fetchData {
    WACloudManageClient *newClient = [WACloudManageClient manageClientWithCredential:[WAConfig sharedConfiguration].manageAuthCred];
    [self showLoader:self.view];
    [newClient fetchBlobPropertiesWithCallBack:self];
}

- (void) saveBtnPressed {
    
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

- (void) switchTriggered:(id)sender {
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self lowerKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return YES;
}

- (void) lowerKeyboard {
    [loggingRetentionDaysField resignFirstResponder];
    [metricsRetentionDaysField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {   
    if (textField == loggingRetentionDaysField) {
        [self shiftView:100];
    } else if (textField == metricsRetentionDaysField) {
        [self shiftView:325];
    }
    return YES;
}

- (void) shiftView:(int)yCoord {    
    [self.mainTableView setContentOffset:CGPointMake(0, yCoord) animated:YES];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) { // Logging
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Delete";
            [cell addSubview:mySwitchDelete];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Read";
            [cell addSubview:mySwitchRead];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Write";
            [cell addSubview:mySwitchWrite];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Retention Enabled?";
            [cell addSubview:mySwitchLoggingRetentionEnabled];
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Retention # Days";
            
            loggingRetentionDaysField.borderStyle = UITextBorderStyleNone;
			loggingRetentionDaysField.backgroundColor = [UIColor clearColor];
			loggingRetentionDaysField.font = [UIFont boldSystemFontOfSize:17];
			loggingRetentionDaysField.userInteractionEnabled = YES;
			loggingRetentionDaysField.keyboardType = UIKeyboardTypeDefault;
			loggingRetentionDaysField.autocapitalizationType = UITextAutocapitalizationTypeWords;
			loggingRetentionDaysField.textAlignment = UITextAlignmentRight;
			loggingRetentionDaysField.delegate = self;
			loggingRetentionDaysField.placeholder = @"0";
			loggingRetentionDaysField.returnKeyType = UIReturnKeyDone;
			loggingRetentionDaysField.autocorrectionType = UITextAutocorrectionTypeNo;
			[cell addSubview:loggingRetentionDaysField];
        }
    } else if (indexPath.section == 1) { // Metrics
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Enabled?";
            [cell addSubview:mySwitchMetricsEnabled];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Include APIs?";
            [cell addSubview:mySwitchIncludeAPIs];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Retention Enabled?";
            [cell addSubview:mySwitchMetricsRetentionEnabled];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Retention # Days";
            
            metricsRetentionDaysField.borderStyle = UITextBorderStyleNone;
			metricsRetentionDaysField.backgroundColor = [UIColor clearColor];
			metricsRetentionDaysField.font = [UIFont boldSystemFontOfSize:17];
			metricsRetentionDaysField.userInteractionEnabled = YES;
			metricsRetentionDaysField.keyboardType = UIKeyboardTypeDefault;
			metricsRetentionDaysField.autocapitalizationType = UITextAutocapitalizationTypeWords;
			metricsRetentionDaysField.textAlignment = UITextAlignmentRight;
			metricsRetentionDaysField.delegate = self;
			metricsRetentionDaysField.placeholder = @"0";
			metricsRetentionDaysField.returnKeyType = UIReturnKeyDone;
			metricsRetentionDaysField.autocorrectionType = UITextAutocorrectionTypeNo;
			[cell addSubview:metricsRetentionDaysField];
        }
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Logging";
    } else if (section == 1) {
        return @"Metrics";
    }
    return @"";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return 4;
    }
    
	return 0;
}

- (NSString *) removeBadCharacters:(NSString *)myStr {
	myStr = [myStr stringByReplacingOccurrencesOfString:@"ï" withString:@""];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"»" withString:@""];
	myStr = [myStr stringByReplacingOccurrencesOfString:@"¿" withString:@""];
    
	return myStr;
}

#pragma mark - WACloudStorageClientDelegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *cleanResponseStr = [self removeBadCharacters:[request responseString]];
    NSLog(@"got into didFetchBlobProperties, result: %@", cleanResponseStr);
    
    TBXML *tbxml = [TBXML tbxmlWithXMLString:cleanResponseStr];
    TBXMLElement *root = tbxml.rootXMLElement;
    
    TBXMLElement *baseLoggingElem = [TBXML childElementNamed:@"Logging" parentElement:root];
    TBXMLElement *baseMetricsElem = [TBXML childElementNamed:@"Metrics" parentElement:root];
    
    if (baseLoggingElem) {
        TBXMLElement *deleteElem = [TBXML childElementNamed:@"Delete" parentElement:baseLoggingElem];
        [mySwitchDelete setOn:[[TBXML textForElement:deleteElem] boolValue] animated:YES];
        
        TBXMLElement *readElem = [TBXML childElementNamed:@"Read" parentElement:baseLoggingElem];
        [mySwitchRead setOn:[[TBXML textForElement:readElem] boolValue] animated:YES];
        
        TBXMLElement *writeElem = [TBXML childElementNamed:@"Write" parentElement:baseLoggingElem];
        [mySwitchWrite setOn:[[TBXML textForElement:writeElem] boolValue] animated:YES];
        
        TBXMLElement *retentionPolicy = [TBXML childElementNamed:@"RetentionPolicy" parentElement:baseLoggingElem];
        TBXMLElement *retEnabled = [TBXML childElementNamed:@"Enabled" parentElement:retentionPolicy];
        [mySwitchLoggingRetentionEnabled setOn:[[TBXML textForElement:retEnabled] boolValue]];
        
        if ([[TBXML textForElement:retEnabled] boolValue]) {
            TBXMLElement *retDays = [TBXML childElementNamed:@"Days" parentElement:retentionPolicy];
            loggingRetentionDaysField.text = [TBXML textForElement:retDays];
        }
    }
    if (baseMetricsElem) {
        TBXMLElement *enabledElem = [TBXML childElementNamed:@"Enabled" parentElement:baseMetricsElem];
        [mySwitchMetricsEnabled setOn:[[TBXML textForElement:enabledElem] boolValue] animated:YES];
        
        TBXMLElement *includeAPIsElem = [TBXML childElementNamed:@"IncludeAPIs" parentElement:baseMetricsElem];
        if (includeAPIsElem) {
            [mySwitchIncludeAPIs setOn:[[TBXML textForElement:includeAPIsElem] boolValue] animated:YES];
        }
        
        TBXMLElement *retentionPolicy = [TBXML childElementNamed:@"RetentionPolicy" parentElement:baseMetricsElem];
        TBXMLElement *retEnabled = [TBXML childElementNamed:@"Enabled" parentElement:retentionPolicy];
        [mySwitchMetricsRetentionEnabled setOn:[[TBXML textForElement:retEnabled] boolValue]];
        
        if ([[TBXML textForElement:retEnabled] boolValue]) {
            TBXMLElement *retDays = [TBXML childElementNamed:@"Days" parentElement:retentionPolicy];
            metricsRetentionDaysField.text = [TBXML textForElement:retDays];
        }
    }
    
    //[self.mainTableView reloadData];
    [self hideLoader:self.view];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"got into didFailReq");
    [self showError:[request error]];
    [self hideLoader:self.view];
}

@end
