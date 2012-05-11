//
//  AddKeysVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "AddKeysVC.h"
#import "WAQueryKey.h"
#import "WAQuery.h"

@interface AddKeysVC ()

@end

@implementation AddKeysVC

@synthesize currQuery = _currQuery;
@synthesize mainTableView = _mainTableView;
@synthesize entitiesArr = _entitiesArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Add Key";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self action:@selector(doneBtnPressed)];
    self.navigationItem.rightBarButtonItem = doneBtn;	
    
    NSLog(@"entites count: %i", [self.entitiesArr count]);
}

- (void) doneBtnPressed {
    [self dismissModalViewControllerAnimated:YES];
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
	    
    /*UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (querySelectedIndex == indexPath.row) {
        [selBtn setBackgroundImage:SELECTED_YES_CELL_IMAGE forState:UIControlStateNormal];
    } else {
        [selBtn setBackgroundImage:SELECTED_NO_CELL_IMAGE forState:UIControlStateNormal];
    }
    selBtn.frame = CGRectMake(8, 10, 25, 25);
    selBtn.tag = indexPath.row;
    [selBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:selBtn]; */
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.mainTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.entitiesArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.currQuery = nil;
    self.entitiesArr = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
