//
//  MonitoringTypeSelVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/21/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "MonitoringTypeSelVC.h"
#import "MonitoringSettingsVC.h"

@interface MonitoringTypeSelVC ()

@end

@implementation MonitoringTypeSelVC

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

- (IBAction) blobServicesBtnPressed {
    MonitoringSettingsVC *aController = [[MonitoringSettingsVC alloc] initWithNibName:@"MonitoringSettings" bundle:nil];
    aController.monitoringSelTypeStr = TYPE_GET_BLOB_PROPERTIES;
    [[self navigationController] pushViewController:aController animated:YES];
}

- (IBAction) tableServicesBtnPressed {
    MonitoringSettingsVC *aController = [[MonitoringSettingsVC alloc] initWithNibName:@"MonitoringSettings" bundle:nil];
    aController.monitoringSelTypeStr = TYPE_GET_TABLE_PROPERTIES;
    [[self navigationController] pushViewController:aController animated:YES];
}

- (IBAction) queueServicesBtnPressed {
    MonitoringSettingsVC *aController = [[MonitoringSettingsVC alloc] initWithNibName:@"MonitoringSettings" bundle:nil];
    aController.monitoringSelTypeStr = TYPE_GET_QUEUE_PROPERTIES;
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
