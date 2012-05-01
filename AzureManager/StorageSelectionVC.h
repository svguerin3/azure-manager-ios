//
//  StorageSelectionVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WACloudStorageClient;

@interface StorageSelectionVC : UIViewController 

- (IBAction) tablesBtnPressed;
- (IBAction) blobDataBtnPressed;
- (IBAction) queuesBtnPressed;

@end
