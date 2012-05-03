//
//  NewAccountVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAccountVC : UIViewController

- (IBAction) addAccountBtnPressed;

@property (nonatomic, retain) IBOutlet UITextField *acctNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *accessKeyTextField;

@end
