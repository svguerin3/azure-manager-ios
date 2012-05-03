//
//  AccountSelectionVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface AccountSelectionVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *mainDel;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
