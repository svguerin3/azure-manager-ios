//
//  HostedServicesListVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudManageClientDelegate.h"

@interface HostedServicesListVC : UIViewController <WACloudManageClientDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate> {
    NSMutableArray *servicesArr;
    
    UIAlertView *certPWAlert;
    UITextField *certPWField;
    
    WACloudManageClient *currClient;
}

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
