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
#import "ASIHTTPRequest.h"

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
- (void)fetchListOfHostedServices;

/**
 Fetch Blob properties asynchronously. 
 */
- (void) fetchBlobPropertiesWithCallBack:(UIViewController *)callbackVC;
   
/**
 Set Blob properties asynchronously. 
 */
- (void) setBlobServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC;
    
/**
 Fetch Table properties asynchronously. 
 */
- (void) fetchTablePropertiesWithCallBack:(UIViewController *)callbackVC;
    
/**
 Fetch Queue properties asynchronously. 
 */
- (void) fetchQueuePropertiesWithCallBack:(UIViewController *)callbackVC;

/**
 Set Queue properties asynchronously. 
 */
- (void) setQueueServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC;

/**
 Create a storage client initialized with the given credential.
 
 @param credential The credentials for Windows Azure storage. 
 
 @returns The newly initialized WACloudStorageClient object.
 */
+ (WACloudManageClient *)manageClientWithCredential:(WAAuthManageCred *)credential;

@end
