//
//  QueryDetailsVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAQuery.h"

@class AppDelegate;

@interface QueryDetailsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    AppDelegate *mainDel;
}

- (void) lowerKeyboard;

@property (nonatomic, retain) IBOutlet UITextField *queryNameField;
@property (nonatomic, retain) IBOutlet UITextView *filterTextView;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) WAQuery *currQuery;
@property BOOL isAddView;

@end
