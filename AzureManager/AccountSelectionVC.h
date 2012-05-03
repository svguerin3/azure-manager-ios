//
//  AccountSelectionVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSelectionVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
