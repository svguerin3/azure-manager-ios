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

- (void)fetchListOfHostedServicesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_LIST_HOSTED_SERVICES withReqBody:@""];
    if (myReq) {
        [myReq setTag:1];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) fetchBlobPropertiesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_BLOB_PROPERTIES withReqBody:@""];
    if (myReq) {
        [myReq setTag:1];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) fetchTablePropertiesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_TABLE_PROPERTIES withReqBody:@""];
    if (myReq) {
        [myReq setTag:1];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) fetchQueuePropertiesWithCallBack:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_GET_QUEUE_PROPERTIES withReqBody:@""];
    if (myReq) {
        [myReq setTag:1];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) setBlobServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_SET_BLOB_SERVICE_PROPERTIES withReqBody:bodyPayload];
    if (myReq) {
        [myReq setTag:2];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) setQueueServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_SET_QUEUE_SERVICE_PROPERTIES withReqBody:bodyPayload];
    if (myReq) {
        [myReq setTag:2];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

- (void) setTableServiceProperties:(NSString *)bodyPayload withCallback:(UIViewController *)callbackVC {
    ASIHTTPRequest *myReq = [_credential authenticatedRequestForType:TYPE_SET_TABLE_SERVICE_PROPERTIES withReqBody:bodyPayload];
    if (myReq) {
        [myReq setTag:2];
        [myReq setDelegate:callbackVC];
        [myReq startAsynchronous];
    }
}

@end
