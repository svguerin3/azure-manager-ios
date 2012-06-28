//
//  ManagementSelVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/28/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "ManagementSelVC.h"
#import "HostedServicesListVC.h"

@interface ManagementSelVC ()

@end

@implementation ManagementSelVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Please Select an Option";
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

- (IBAction) listHostedServicesBtnPressed {
    HostedServicesListVC *aController = [[HostedServicesListVC alloc] initWithNibName:@"HostedServicesList" bundle:nil];
    [[self navigationController] pushViewController:aController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
