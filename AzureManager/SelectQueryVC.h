//
//  SelectQueryVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface SelectQueryVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *mainDel;
    int querySelectedIndex;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
