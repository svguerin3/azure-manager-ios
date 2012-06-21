//
//  WACloudManageClient.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WACloudManageClient.h"
#import "WACloudManageClientDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation WACloudManageClient

@synthesize delegate = _delegate;

- (id)initWithCredential:(WAAuthManageCred *)credential
{
	if ((self = [super init])) {
		_credential = credential;
	}
	
	return self;
}

+ (WACloudManageClient *) manageClientWithCredential:(WAAuthManageCred *)credential
{
	return [[self alloc] initWithCredential:credential];
}

- (void)fetchListOfHostedServices {
    //NSMutableURLRequest *myReq = [_credential authenticatedRequestForType:TYPE_LIST_HOSTED_SERVICES];
    //NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:myReq delegate:self startImmediately:YES];
    //[myConn start]; 
}

- (void) fetchBlobPropertiesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_BLOB_PROPERTIES];
    [myReq setDelegate:callbackVC];
    [myReq startAsynchronous];
}

@end
