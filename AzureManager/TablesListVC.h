//
//  TablesListVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WACloudStorageClient.h"

@interface TablesListVC : UIViewController <WACloudStorageClientDelegate, UITableViewDelegate, UITableViewDataSource> {
@private
	WACloudStorageClient *storageClient;
    NSMutableArray *_localStorageList;
    WAResultContinuation *_resultContinuation;
    BOOL _fetchedResults;
}

- (void)fetchTableData;

@property (nonatomic, retain) WAResultContinuation *resultContinuation;
@property (nonatomic, retain) NSMutableArray *localStorageList;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@end
