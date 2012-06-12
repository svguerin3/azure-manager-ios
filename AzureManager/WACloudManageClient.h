//
//  WACloudManageClient.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAuthManageCred.h"
#import "WACloudManageClientDelegate.h"


@protocol WACloudManageClientDelegate;

/**
 The cloud management client is used to invoke operations on, and return data from, Windows Azure Management APIs. 
 */
@interface WACloudManageClient : NSObject {
@private
	WAAuthManageCred* _credential;
    __unsafe_unretained id<WACloudManageClientDelegate> _delegate;
}

///---------------------------------------------------------------------------------------
/// @name Setting the Delegate
///---------------------------------------------------------------------------------------

/**
 The delegate is sent messages when content is loaded or errors occur
 */
@property (assign) id<WACloudManageClientDelegate> delegate;

/**
 Fetch a list of hosted services asynchronously. 
 */
- (void)fetchListOfHostedServices:(void (^)(NSArray *, NSError *))block;

/**
 Create a storage client initialized with the given credential.
 
 @param credential The credentials for Windows Azure storage. 
 
 @returns The newly initialized WACloudStorageClient object.
 */
+ (WACloudManageClient *)manageClientWithCredential:(WAAuthManageCred *)credential;

@end
