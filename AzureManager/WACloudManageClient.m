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
    
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"got into canAuth, method: %@", protectionSpace.authenticationMethod);
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"got into didReceiveAuthChallenge, host: %@", challenge.protectionSpace.host);
    NSArray *trustedHosts = [NSArray arrayWithObject:@"management.core.windows.net"];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - NSURLRequest Delegate Methods

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"got into connectionDidFinishLoading");
    
    NSString *responseStr = [[NSString alloc] initWithData:_data encoding: NSUTF8StringEncoding];
    NSLog(@"data length: %i | responseStr: %@", [_data length], responseStr);
    
    if ([_delegate respondsToSelector:@selector(storageClient:didFetchHostedServices:)]) {
        [_delegate storageClient:self didFetchHostedServices:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"got into didFailWithError");
    
    if ([_delegate respondsToSelector:@selector(storageClient:didFailRequest:withError:)]) {
        [_delegate storageClient:self didFailRequest:nil withError:error];
    }
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
