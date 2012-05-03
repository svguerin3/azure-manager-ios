//
//  AccountSelectionVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "AccountSelectionVC.h"
#import "MainMenuVC.h"
#import "AppDelegate.h"
#import "AccountData.h"
#import "NewAccountVC.h"

@interface AccountSelectionVC ()

@end

@implementation AccountSelectionVC

@synthesize mainTableView = _mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Select an Account";
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
	self.mainTableView.backgroundColor = [UIColor clearColor];
    
    mainDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self action:@selector(addBtnPressed)] ;
	self.navigationItem.rightBarButtonItem = plusBtn;  
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.mainTableView reloadData];
}

- (void) addBtnPressed {
    NewAccountVC *aController = [[NewAccountVC alloc] initWithNibName:@"NewAccount" bundle:nil];
    [[self navigationController] pushViewController:aController animated:YES];
}

#pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    cell.textLabel.numberOfLines = 0;
	
    // temporary for testing
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Vincent Trial Account";
    } else {
        AccountData *currAcct = [mainDel.accountsList objectAtIndex:indexPath.row-1];
        cell.textLabel.text = currAcct.accountName;    
    }
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1 + [mainDel.accountsList count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountData *currAcct = [[AccountData alloc] init];
    
    // THIS IS TEMPORARY FOR TESTING PURPOSES
    if (indexPath.row == 0) {
        currAcct.accountName = TEMP_ACCOUNTNAME;
        currAcct.accessKey = TEMP_ACCESSKEY;
    } else {
        currAcct = [mainDel.accountsList objectAtIndex:indexPath.row-1];
    }
    // END TESTING
    
    [[WAConfig sharedConfiguration] initCredentialsWithAccountName:currAcct.accountName withAccessKey:currAcct.accessKey];
    
    MainMenuVC *aController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        aController = [[MainMenuVC alloc] initWithNibName:@"MainMenu_iPhone" bundle:nil]; 
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        aController = [[MainMenuVC alloc] initWithNibName:@"MainMenu_iPad" bundle:nil]; 
    }    
    [[self navigationController] pushViewController:aController animated:YES];
    
    [self.mainTableView reloadData];
}

- (IBAction) EditTable:(id)sender {
	if(self.editing) {
		[super setEditing:NO animated:NO]; 
		[self.mainTableView setEditing:NO animated:YES];
		[self.mainTableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	} else {
		[super setEditing:YES animated:YES]; 
		[self.mainTableView setEditing:YES animated:YES];
		[self.mainTableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row != 0) { // TEMPORARY STUFF
            [mainDel.accountsList removeObjectAtIndex:indexPath.row-1];
            [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self showGenericAlert:@"" withTitle:@"Can't delete that one"];
        }
	}
} 

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {	
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mainTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
