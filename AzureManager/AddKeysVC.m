//
//  AddKeysVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "AddKeysVC.h"
#import "WAQueryKey.h"
#import "WAQuery.h"
#import "WATableEntity.h"

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
        self.title = @"Add Keys";
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
    
    // group together keys
    uniqueEntitiesArr = [[NSMutableArray alloc] init];
    for (WATableEntity *currEntity in self.entitiesArr) {
        if (![uniqueEntitiesArr containsObject:currEntity.partitionKey]) {
            [uniqueEntitiesArr addObject:currEntity.partitionKey];
        }
    }
}

- (void) doneBtnPressed {
    for (int i=0; i<[uniqueEntitiesArr count]; i++) {
        if (keySelected[i]) {
            if (![self keyAlreadyExists:[uniqueEntitiesArr objectAtIndex:i]]) { 
                WAQueryKey *newKey = [[WAQueryKey alloc] init];
                newKey.keyText = [uniqueEntitiesArr objectAtIndex:i];
                newKey.keySelected = [NSNumber numberWithBool:NO];
                [self.currQuery.listOfKeys addObject:newKey];
            }
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL) keyAlreadyExists:(NSString *)keyStr {
    for (WAQueryKey *currKey in self.currQuery.listOfKeys) {
        if ([currKey.keyText isEqualToString:keyStr]) {
            return YES;
        }
    }
    return NO;
}

- (void) selectionBtnPressed:(id)sender {
    if (keySelected[[sender tag]]) {
        keySelected[[sender tag]] = NO;
    } else {
        keySelected[[sender tag]] = YES;
    }
    [self.mainTableView reloadData];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [subView removeFromSuperview]; // draw the buttons from scratch for now
            }
        }
    }
	    
    UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (keySelected[indexPath.row]) {
        [selBtn setBackgroundImage:SELECTED_YES_CELL_IMAGE forState:UIControlStateNormal];
    } else {
        [selBtn setBackgroundImage:SELECTED_NO_CELL_IMAGE forState:UIControlStateNormal];
    }
    selBtn.frame = CGRectMake(8, 10, 25, 25);
    selBtn.tag = indexPath.row;
    [selBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:selBtn];

    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", PADDING_FOR_SELECTION_CELLS, [uniqueEntitiesArr objectAtIndex:indexPath.row]];
    
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
	return [uniqueEntitiesArr count];
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
