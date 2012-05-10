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

@synthesize keyTextField = _keyTextField;
@synthesize currQuery = _currQuery;

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

    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                  target:self action:@selector(cancelBtnPressed)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self action:@selector(doneBtnPressed)];
    self.navigationItem.rightBarButtonItem = doneBtn;	
}

- (void) cancelBtnPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) doneBtnPressed {
    if ([self.keyTextField.text length] > 0) {
        WAQueryKey *newKey = [[WAQueryKey alloc] init];
        newKey.keyText = self.keyTextField.text;
        
        NSLog(@"count1: %i", [self.currQuery.listOfKeys count]);
        [self.currQuery.listOfKeys addObject:newKey];
        NSLog(@"count2: %i", [self.currQuery.listOfKeys count]);
        
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self showGenericAlert:@"Please enter text for this key" withTitle:@""];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.keyTextField = nil;
    self.currQuery = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
