//
//  WACloudManageClientDelegate.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WACloudManageClient.h"

@class WACloudManageClient;

@protocol WACloudManageClientDelegate <NSObject>

@optional

- (void)storageClient:(WACloudManageClient *)client didFailRequest:(NSURLRequest*)request withError:(NSError *)error;
- (void)storageClient:(WACloudManageClient *)client didFetchHostedServices:(NSArray *)services;
- (void)storageClient:(WACloudManageClient *)client didFetchBlobProperties:(NSString *)returnXMLStr;

@end
