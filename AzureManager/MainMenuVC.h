//
//  MainMenuVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudManageClientDelegate.h"

@interface MainMenuVC : UIViewController <WACloudManageClientDelegate>

- (IBAction) storageBtnPressed;
- (IBAction) monitoringBtnPressed;
- (IBAction) managementBtnPressed;

@end
