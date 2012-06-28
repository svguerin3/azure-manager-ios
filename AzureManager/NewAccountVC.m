//
//  NewAccountVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "NewAccountVC.h"
#import "AppDelegate.h"
#import "AccountData.h"

@interface NewAccountVC ()

@end

@implementation NewAccountVC

@synthesize acctNameTextField = _acctNameTextField;
@synthesize accessKeyTextField = _accessKeyTextField;
@synthesize subIDTextField = _subIDTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Add Account";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self action:@selector(cancelBtnPresent)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
}

- (void) cancelBtnPresent {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) addAccountBtnPressed {
    if ([self.acctNameTextField.text length] > 0 && [self.accessKeyTextField.text length] > 0) {
        AccountData *newData = [[AccountData alloc] init];
        newData.accountName = self.acctNameTextField.text;
        newData.accessKey = self.accessKeyTextField.text;
        newData.subscriptionID = self.subIDTextField.text;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.accountsList addObject:newData];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self showGenericAlert:@"Error" withTitle:@"Please fill in both fields"];
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.accessKeyTextField = nil;
    self.acctNameTextField = nil;
    self.subIDTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
