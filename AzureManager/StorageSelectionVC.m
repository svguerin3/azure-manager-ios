//
//  StorageSelectionVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "StorageSelectionVC.h"
#import "TablesListVC.h"

@interface StorageSelectionVC ()

@end

@implementation StorageSelectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Storage Selection";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (IBAction) tablesBtnPressed {
    TablesListVC *aController = [[TablesListVC alloc] initWithNibName:@"TablesList" bundle:nil];
    [[self navigationController] pushViewController:aController animated:YES];
}

- (IBAction) blobDataBtnPressed {

}

- (IBAction) queuesBtnPressed {
    
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
