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
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_BLOB_PROPERTIES withReqBody:@""];
    [myReq setTag:1];
    [myReq setDelegate:callbackVC];
    [myReq startAsynchronous];
}

- (void) fetchTablePropertiesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_TABLE_PROPERTIES withReqBody:@""];
    [myReq setTag:1];
    [myReq setDelegate:callbackVC];
    [myReq startAsynchronous];
}

- (void) setBlobServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_SET_BLOB_SERVICE_PROPERTIES withReqBody:bodyPayload];
    [myReq setTag:2];
    [myReq setDelegate:callbackVC];
    [myReq startAsynchronous];
}

@end
