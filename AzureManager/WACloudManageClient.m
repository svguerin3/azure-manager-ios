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

- (void)fetchListOfHostedServices:(void (^)(NSArray *, NSError *))block {
    NSArray *myRetArr = [NSArray arrayWithObjects:@"1", @"2", nil];
    
    if (block) {
        block(myRetArr, nil);
    } else if ([_delegate respondsToSelector:@selector(storageClient:didFetchHostedServices:)]) {
        [_delegate storageClient:self didFetchHostedServices:myRetArr];
    }    
}

@end
