//
//  BlobListVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudStorageClient.h"

@interface BlobListVC : UIViewController <WACloudStorageClientDelegate, UITableViewDelegate, UITableViewDataSource> {
@private
	WACloudStorageClient *storageClient;
    NSMutableArray *_localStorageList;
    WAResultContinuation *_resultContinuation;
    BOOL _fetchedResults;
    
    int totalImgCount;
}

- (void)fetchData;

@property (nonatomic, retain) WAResultContinuation *resultContinuation;
@property (nonatomic, retain) NSMutableArray *localStorageList;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) WABlobContainer *currContainer;

@end
