//
//  WACloudManageClient.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WACloudManageClient.h"
#import "WACloudManageClientDelegate.h"

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
    
    NSMutableURLRequest *myReq = [_credential authenticatedRequestForType:TYPE_LIST_HOSTED_SERVICES];
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:myReq delegate:self startImmediately:YES];    
    [myConn start];
                            
    /*if (block) {
        block(myRetArr, nil);
    } else if ([_delegate respondsToSelector:@selector(storageClient:didFetchHostedServices:)]) {
        [_delegate storageClient:self didFetchHostedServices:myRetArr];
    } */   
}

#pragma mark - NSURLRequest Delegate Methods

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"got into connectionDidFinishLoading");
    
    NSString *responseStr = [[NSString alloc] initWithData:_data encoding: NSUTF8StringEncoding];
    NSLog(@"responseStr: %@", responseStr);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"got into didFailWithError");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"got into didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"did receive data");
	if (!_data) {
		_data = [data mutableCopy];
	} else {
		[_data appendData:data];
	}
}

@end
