//
//  MainMenuVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "MainMenuVC.h"
#import "StorageSelectionVC.h"
#import "WACloudManageClient.h"
#import "MonitoringTypeSelVC.h"
#import "ManagementSelVC.h"

@interface MainMenuVC ()

@end

@implementation MainMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Main Menu";
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

- (IBAction) storageBtnPressed {
    StorageSelectionVC *aController = [[StorageSelectionVC alloc] initWithNibName:@"StorageSelection" bundle:nil];
    [[self navigationController] pushViewController:aController animated:YES];
}

- (IBAction) monitoringBtnPressed {
    MonitoringTypeSelVC *aController = [[MonitoringTypeSelVC alloc] initWithNibName:@"MonitoringTypeSel" bundle:nil];
    [[self navigationController] pushViewController:aController animated:YES];
}

- (IBAction) managementBtnPressed {
    ManagementSelVC *aController = [[ManagementSelVC alloc] initWithNibName:@"ManagementSel" bundle:nil];
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
