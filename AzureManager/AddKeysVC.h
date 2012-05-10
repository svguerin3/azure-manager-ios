//
//  AddKeysVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAQuery.h"

@interface AddKeysVC : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *keyTextField;
@property (nonatomic, retain) WAQuery *currQuery;

@end
