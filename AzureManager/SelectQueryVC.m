//
//  SelectQueryVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "SelectQueryVC.h"
#import "QueryDetailsVC.h"
#import "AppDelegate.h"
#import "WAConfig.h"

@interface SelectQueryVC ()

@end

@implementation SelectQueryVC

@synthesize mainTableView = _mainTableView;
@synthesize entitiesArr = _entitiesArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Select Query";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Tableview init code
    self.mainTableView.dataSource = self;
	self.mainTableView.delegate = self;
	((UIScrollView *)self.mainTableView).delegate = self;
	self.mainTableView.scrollEnabled = YES;
	self.mainTableView.showsVerticalScrollIndicator = YES;
	self.mainTableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								   target:self action:@selector(addBtnPressed)];
	self.navigationItem.rightBarButtonItem = addButton;	
    
    querySelectedIndex = [WAConfig sharedConfiguration].querySelectedIndex;
    
    mainDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.mainTableView reloadData];
}

- (void) addBtnPressed {
    QueryDetailsVC *aController = [[QueryDetailsVC alloc] initWithNibName:@"QueryDetails" bundle:nil];
    aController.entitiesArr = self.entitiesArr;
    aController.isAddView = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aController];
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview]; // draw the buttons from scratch for now
            }
        }
    }
	
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@Default", PADDING_FOR_SELECTION_CELLS];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        WAQuery *currQuery = [mainDel.queriesList objectAtIndex:indexPath.row-1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", PADDING_FOR_SELECTION_CELLS, currQuery.queryName];
    }
    
    UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (querySelectedIndex == indexPath.row) {
        [selBtn setBackgroundImage:SELECTED_YES_CELL_IMAGE forState:UIControlStateNormal];
    } else {
        [selBtn setBackgroundImage:SELECTED_NO_CELL_IMAGE forState:UIControlStateNormal];
    }
    selBtn.frame = CGRectMake(8, 10, 25, 25);
    selBtn.tag = indexPath.row;
    [selBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:selBtn];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    QueryDetailsVC *aController = [[QueryDetailsVC alloc] initWithNibName:@"QueryDetails" bundle:nil];
    aController.currQuery = [mainDel.queriesList objectAtIndex:indexPath.row-1];
    aController.isAddView = NO;
    aController.entitiesArr = self.entitiesArr;
    [[self navigationController] pushViewController:aController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.mainTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1 + [mainDel.queriesList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

- (void) selectionBtnPressed:(id)sender {
    querySelectedIndex = [WAConfig sharedConfiguration].querySelectedIndex = [sender tag];
    [self.mainTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
    self.entitiesArr = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
