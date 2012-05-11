//
//  AddKeysVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAQuery.h"

@interface AddKeysVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) WAQuery *currQuery;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet NSArray *entitiesArr;

@end
