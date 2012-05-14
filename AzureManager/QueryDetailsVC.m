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
#import "AddKeysVC.h"
#import "WAQueryKey.h"

@interface QueryDetailsVC ()

@end

@implementation QueryDetailsVC

@synthesize filterTextView = _filterTextView;
@synthesize mainTableView = _mainTableView;
@synthesize currQuery;
@synthesize queryNameField = _queryNameField;
@synthesize isAddView;
@synthesize entitiesArr = _entitiesArr;

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
        
        self.currQuery = [[WAQuery alloc] init];
    } else {
        self.title = @"Edit Query";
    }
    
    self.filterTextView.layer.borderWidth = 1;
    self.filterTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    if (self.currQuery) {
        self.queryNameField.text = self.currQuery.queryName;
        self.filterTextView.text = self.currQuery.filterStr;
    }
    
    [self.mainTableView setEditing:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.mainTableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    self.currQuery.filterStr = self.filterTextView.text;
}

- (void) cancelBtnPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) doneBtnPressed {
    if ([self.queryNameField.text length] > 0) {
        if (isAddView) {
            self.currQuery.queryName = self.queryNameField.text;
            self.currQuery.filterStr = self.filterTextView.text;
            [mainDel.queriesList addObject:self.currQuery];
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
    self.entitiesArr = nil;
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
    if ([sender tag] == 0) {
        if ([self.currQuery.allKeysSelected boolValue]) {
            [self.currQuery setAllKeysSelected:[NSNumber numberWithBool:NO]];
        } else {
            [self.currQuery setAllKeysSelected:[NSNumber numberWithBool:YES]];
        }
    } else {
        WAQueryKey *currKey = [self.currQuery.listOfKeys objectAtIndex:[sender tag]-1];
        if ([currKey.keySelected boolValue]) {
            [currKey setKeySelected:[NSNumber numberWithBool:NO]];
        } else {
            [currKey setKeySelected:[NSNumber numberWithBool:YES]];
        }
    }
    
    // check to make sure something was selected
    BOOL atLeastOneKeySelected = NO;
    for (WAQueryKey *currKey in self.currQuery.listOfKeys) {
        if ([currKey.keySelected boolValue]) {
            atLeastOneKeySelected = YES;
        }
    }
    
    if (![self.currQuery.allKeysSelected boolValue] && !atLeastOneKeySelected) {
        [self.currQuery setAllKeysSelected:[NSNumber numberWithBool:YES]];
        [self showGenericAlert:@"At least one key must be selected." withTitle:@""];
    }
    
    [self.mainTableView reloadData];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*} else {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview]; // draw the buttons from scratch for now
            }
        }
    }*/
    
    UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selBtn.tag = indexPath.row;
    [selBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 0) { // "All Keys" row
        cell.textLabel.text = [NSString stringWithFormat:@"%@ALL Keys", PADDING_FOR_SELECTION_CELLS];
        cell.backgroundColor = [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
        
        selBtn.frame = CGRectMake(19, 11, 25, 25);
        
        if ([self.currQuery.allKeysSelected boolValue]) {
            [selBtn setBackgroundImage:SELECTED_YES_CELL_IMAGE forState:UIControlStateNormal];
        } else {
            [selBtn setBackgroundImage:SELECTED_NO_CELL_IMAGE forState:UIControlStateNormal];
        }
        [cell addSubview:selBtn];
    } else if (indexPath.row == (1 + 1 + [self.currQuery.listOfKeys count])-1) { // "Add Key" row
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@Add Keys", PADDING_FOR_SELECTION_CELLS];
        
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 40, 30)];
        addImageView.image = [UIImage imageNamed:@"iphone-plus-sign-icon.jpg"];
        [cell addSubview:addImageView];
    } else { // Custom key rows
        WAQueryKey *currKey = [self.currQuery.listOfKeys objectAtIndex:indexPath.row-1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@", PADDING_FOR_SELECTION_CELLS, currKey.keyText];
        [cell addSubview:selBtn];
        
        selBtn.frame = CGRectMake(50, 11, 25, 25);
        
        if ([currKey.keySelected boolValue]) {
            [selBtn setBackgroundImage:SELECTED_YES_CELL_IMAGE forState:UIControlStateNormal];
        } else {
            [selBtn setBackgroundImage:SELECTED_NO_CELL_IMAGE forState:UIControlStateNormal];
        }
        [cell addSubview:selBtn];
    }
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lowerKeyboard];
    
    if (indexPath.row == (1 + [self.currQuery.listOfKeys count])) { // add key
        AddKeysVC *aController = [[AddKeysVC alloc] initWithNibName:@"AddKeys" bundle:nil];
        aController.currQuery = self.currQuery;
        aController.entitiesArr = self.entitiesArr;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aController];
        [self presentModalViewController:navController animated:YES];
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

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {	
    WAQueryKey *currKey = [self.currQuery.listOfKeys objectAtIndex:fromIndexPath.row-1];
	[self.currQuery.listOfKeys removeObjectAtIndex:fromIndexPath.row-1];
	[self.currQuery.listOfKeys insertObject:currKey atIndex:toIndexPath.row-1];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0 && indexPath.row != (1 + [self.currQuery.listOfKeys count])) {
        return YES;
    }
    return NO;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.row > 0 && indexPath.row != (1 + [self.currQuery.listOfKeys count])) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
