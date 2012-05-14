//
//  EntityDetailVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/8/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "EntityDetailVC.h"
#import "WATableEntity.h"
#import "PropertyDetailVC.h"

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
    NSString *infoAlertStr = [NSString stringWithFormat:@"Total # of Properties for this Entity: %i", [self.currEntity.keys count]];
    [self showGenericAlert:infoAlertStr withTitle:@"Info"];
}

- (IBAction)viewTypeFilterBtnPressed:(id)sender {
    UISegmentedControl *currControl = (UISegmentedControl *)sender;
    
    if (currControl.selectedSegmentIndex == listViewIndex) {
        objViewSelected = NO;
    } else if (currControl.selectedSegmentIndex == objViewIndex) {
        objViewSelected = YES;
    }
    [self.mainTableView reloadData];
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
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if (objViewSelected) {
        NSString *currPropertyKey = [self.currEntity.keys objectAtIndex:indexPath.row];
        NSDictionary *propertyDict = [NSDictionary dictionaryWithObject:[self.currEntity objectForKey:currPropertyKey] 
                                                                 forKey:currPropertyKey];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [propertyDict description]];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.textLabel.numberOfLines = 0;
    } else {
        NSString *currEntityPropertyKeyStr = [self.currEntity.keys objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.text = [NSString stringWithFormat:@"key: %@\nval: %@", currEntityPropertyKeyStr, [self.currEntity objectForKey:currEntityPropertyKeyStr]];
        cell.textLabel.numberOfLines = 2;
    }
    
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (objViewSelected) {
        NSString *currPropertyKey = [self.currEntity.keys objectAtIndex:indexPath.row];
        NSDictionary *propertyDict = [NSDictionary dictionaryWithObject:[self.currEntity objectForKey:currPropertyKey] 
                                                                 forKey:currPropertyKey];
        NSString *objDataStr = [propertyDict description];
        CGSize labelSize = CGSizeMake(200.0, 20.0);
        if ([objDataStr length] > 0) {
            labelSize = [objDataStr sizeWithFont: [UIFont boldSystemFontOfSize: 12.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
        }
        return labelSize.height;
    }
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyDetailVC *aController = [[PropertyDetailVC alloc] initWithNibName:@"PropertyDetail" bundle:nil];
    aController.currEntity = self.currEntity;
    aController.propertyKeyStr = [self.currEntity.keys objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:aController animated:YES];
    
    [tableView reloadData];
}


@end
