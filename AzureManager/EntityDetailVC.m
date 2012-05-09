//
//  EntityDetailVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/8/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "EntityDetailVC.h"
#import "WATableEntity.h"
#import "PropertyListVC.h"

@interface EntityDetailVC ()

@end

@implementation EntityDetailVC

@synthesize mainTableView = _mainTableView;
@synthesize currEntity = _currEntity;
@synthesize entityKeyInfoLbl = _entityKeyInfoLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Entity Properties";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.entityKeyInfoLbl.text = [NSString stringWithFormat:@"PartitionKey: %@\n RowKey: %@", self.currEntity.partitionKey, self.currEntity.rowKey];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(infoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void) infoBtnPressed {
    
}

- (IBAction)viewTypeFilterBtnPressed:(id)sender {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
    self.currEntity = nil;
    self.entityKeyInfoLbl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currEntity.keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.numberOfLines = 2;
    
    NSString *currEntityPropertyKeyStr = [self.currEntity.keys objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"key: %@\nval: %@", currEntityPropertyKeyStr, [self.currEntity objectForKey:currEntityPropertyKeyStr]];
    
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyListVC *aController = [[PropertyListVC alloc] initWithNibName:@"PropertyList" bundle:nil];
    aController.currEntity = self.currEntity;
    aController.propertyKeyStr = [self.currEntity.keys objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:aController animated:YES];
    
    [tableView reloadData];
}


@end
