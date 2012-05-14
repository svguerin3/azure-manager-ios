//
//  StorageSelectionVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudStorageClient.h"

typedef enum StorageSelectionInd {
	tablesSectionInd = 0,
	blobsSectionInd = 1,
    queuesSectionInd = 2
} StorageSelectionInd;

@class WACloudStorageClient;

@interface StorageSelectionVC : UIViewController <WACloudStorageClientDelegate, UITableViewDelegate, UITableViewDataSource> {
@private
    WACloudStorageClient *storageClient;
    NSMutableArray *_localStorageList;
    WAResultContinuation *_resultContinuation;
    BOOL _fetchedResults;
    BOOL fetchedBlobs, fetchedTables, fetchedQueues;
    int countTables, countBlobContainers, countQueues;
}

- (void)fetchData;
- (void) checkToRemoveSpinner;

@property (nonatomic, retain) WAResultContinuation *resultContinuation;
@property (nonatomic, retain) NSMutableArray *localStorageList;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
