//
//  QueryDetailsVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "QueryDetailsVC.h"
#import <QuartzCore/QuartzCore.h>

@interface QueryDetailsVC ()

@end

@implementation QueryDetailsVC

@synthesize filterTextView = _filterTextView;
@synthesize mainTableView = _mainTableView;
@synthesize currQuery;
@synthesize queryNameField = _queryNameField;

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

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                  target:self action:@selector(doneBtnPressed)];
	self.navigationItem.rightBarButtonItem = addButton;	
    
    self.filterTextView.layer.borderWidth = 1;
    self.filterTextView.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void) doneBtnPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.filterTextView = nil;
    self.mainTableView = nil;
    self.queryNameField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self lowerKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self lowerKeyboard];
	
	return YES;
}

- (void) lowerKeyboard {
	[self.queryNameField becomeFirstResponder];
	[self.queryNameField resignFirstResponder];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ALL Keys", PADDING_FOR_SELECTION_CELLS];
        cell.backgroundColor = [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
    } else if (indexPath.row == (1 + 1 + [self.currQuery.listOfKeys count])-1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@Add Keys", PADDING_FOR_SELECTION_CELLS];
        
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 40, 30)];
        addImageView.image = [UIImage imageNamed:@"iphone-plus-sign-icon.jpg"];
        [cell addSubview:addImageView];                                                                                    
    } else {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lowerKeyboard];
    
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == (1 + 1 + [self.currQuery.listOfKeys count])-1) {
                                                                                           
    } else {
        
    }
    
    [self.mainTableView reloadData];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1 + 1 + [self.currQuery.listOfKeys count]; // 1 for "ALL Keys" option and 1 for "Add Keys"
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

@end
