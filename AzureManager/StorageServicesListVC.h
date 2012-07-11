//
//  StorageServicesListVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 7/11/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudManageClientDelegate.h"

@interface StorageServicesListVC : UIViewController <WACloudManageClientDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate> {
    NSMutableArray *servicesArr;
    
    UIAlertView *certPWAlert;
    UITextField *certPWField;
    
    WACloudManageClient *currClient;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
