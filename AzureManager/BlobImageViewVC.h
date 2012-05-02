//
//  BlobImageViewVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudStorageClient.h"

@class WABlob;

@interface BlobImageViewVC : UIViewController {
    WACloudStorageClient *storageClient;
}

@property (nonatomic, retain) IBOutlet UIImageView *blobImgView;
@property (nonatomic, retain) IBOutlet WABlob *currBlob;

@end
