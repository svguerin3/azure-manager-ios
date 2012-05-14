//
//  PropertyDetailVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/8/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "PropertyDetailVC.h"
#import "WATableEntity.h"

@interface PropertyDetailVC ()

@end

@implementation PropertyDetailVC

@synthesize propKeyLbl = _propKeyLbl;
@synthesize propValTextView = _propValTextView;
@synthesize currEntity = _currEntity;
@synthesize propertyKeyStr = _propertyKeyStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Property";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.propKeyLbl.text = [NSString stringWithFormat:@"Key: %@", self.propertyKeyStr];
    self.propValTextView.text = [self.currEntity objectForKey:self.propertyKeyStr];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    //UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    //[infoButton addTarget:self action:@selector(infoBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void) infoBtnPressed {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.propKeyLbl = nil;
    self.propValTextView = nil;
    self.currEntity = nil;
    self.propertyKeyStr = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
