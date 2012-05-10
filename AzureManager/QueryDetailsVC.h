//
//  QueryDetailsVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAQueryModel.h"

@interface QueryDetailsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (void) lowerKeyboard;

@property (nonatomic, retain) IBOutlet UITextField *queryNameField;
@property (nonatomic, retain) IBOutlet UITextView *filterTextView;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) WAQueryModel *currQuery;

@end
