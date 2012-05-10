//
//  QueryDetailsVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "QueryDetailsVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WAQuery.h"
#import "AppDelegate.h"

@interface QueryDetailsVC ()

@end

@implementation QueryDetailsVC

@synthesize filterTextView = _filterTextView;
@synthesize mainTableView = _mainTableView;
@synthesize currQuery;
@synthesize queryNameField = _queryNameField;
@synthesize isAddView;

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

    mainDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (isAddView) {
        self.title = @"Create Query";
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                    target:self action:@selector(cancelBtnPressed)];
        self.navigationItem.leftBarButtonItem = cancelBtn;
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                  target:self action:@selector(doneBtnPressed)];
        self.navigationItem.rightBarButtonItem = doneBtn;	
    } else {
        self.title = @"Edit Query";
    }
    
    self.filterTextView.layer.borderWidth = 1;
    self.filterTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if (self.currQuery) {
        self.queryNameField.text = self.currQuery.queryName;
    }
}

- (void) cancelBtnPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) doneBtnPressed {
    if ([self.queryNameField.text length] > 0) {
        if (isAddView) {
            WAQuery *newQuery = [[WAQuery alloc] init];
            newQuery.queryName = self.queryNameField.text;
            NSLog(@"count1: %i", [mainDel.queriesList count]);
            [mainDel.queriesList addObject:newQuery];
            NSLog(@"count2: %i", [mainDel.queriesList count]);
        }
        
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self showGenericAlert:@"Please enter a name for this query" withTitle:@""];
    }
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

- (void) selectionBtnPressed:(id)sender {
    keySelectedIndex = [sender tag];
    [self.mainTableView reloadData];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview]; // draw the buttons from scratch for now
            }
        }
    }
    
    UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (keySelectedIndex == indexPath.row) {
        [selBtn setBackgroundImage:[UIImage imageNamed:@"isSelected.png"] forState:UIControlStateNormal];
    } else {
        [selBtn setBackgroundImage:[UIImage imageNamed:@"NotSelected.png"] forState:UIControlStateNormal];
    }
    selBtn.frame = CGRectMake(19, 11, 25, 25);
    selBtn.tag = indexPath.row;
    [selBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 0) { // "All Keys" row
        cell.textLabel.text = [NSString stringWithFormat:@"%@ALL Keys", PADDING_FOR_SELECTION_CELLS];
        cell.backgroundColor = [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
        [cell addSubview:selBtn];
    } else if (indexPath.row == (1 + 1 + [self.currQuery.listOfKeys count])-1) { // "Add Key" row
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@Add Keys", PADDING_FOR_SELECTION_CELLS];
        
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 40, 30)];
        addImageView.image = [UIImage imageNamed:@"iphone-plus-sign-icon.jpg"];
        [cell addSubview:addImageView];
    } else { // Custom key rows
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        [cell addSubview:selBtn];
        
    }
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lowerKeyboard];
    
    if (indexPath.row == (1 + 1 + [self.currQuery.listOfKeys count])-1) { // add key
                                                                                           
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
