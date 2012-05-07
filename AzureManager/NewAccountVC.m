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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (IBAction) addAccountBtnPressed {
    if ([self.acctNameTextField.text length] > 0 && [self.accessKeyTextField.text length] > 0) {
        AccountData *newData = [[AccountData alloc] init];
        newData.accountName = self.acctNameTextField.text;
        newData.accessKey = self.accessKeyTextField.text;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.accountsList addObject:newData];
        [[self navigationController] popViewControllerAnimated:YES];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
