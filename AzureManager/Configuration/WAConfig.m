//
//  WAConfig.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WAConfig.h"
#import "WAAuthenticationCredential.h"
#import "WAAuthManageCred.h"

@implementation WAConfig

@synthesize storageAuthCred;
@synthesize manageAuthCred;
@synthesize querySelectedIndex;

+ (WAConfig*)sharedConfiguration
{
	static dispatch_once_t once;
    static WAConfig *sharedFoo;
    dispatch_once(&once, ^ { sharedFoo = [self new]; });
    return sharedFoo;
}

- (id)init
{
	if(!(self = [super init])) {
		return nil;
	}
    return self;
}

- (void) initCredentialsWithAccountName:(NSString *)accountName withAccessKey:(NSString *)accessKey {
    self.storageAuthCred = [WAAuthenticationCredential credentialWithAzureServiceAccount:accountName 
                                                        accessKey:accessKey];
    self.manageAuthCred = [WAAuthManageCred credentialWithAzureServiceAccount:accountName 
                                                                    accessKey:accessKey];
}

@end
