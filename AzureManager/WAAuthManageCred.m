//
//  WAAuthManageCred.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WAAuthManageCred.h"

@implementation WAAuthManageCred

- (id)initWithAzureServiceAccount:(NSString*)name accessKey:(NSString*)key
{	
	if ((self = [super init]) != nil) {
		_usesProxy = NO;
		_accountName = [name copy];
		_accessKey = [key copy];
	}
	
	return self;
}

+ (WAAuthManageCred *)credentialWithAzureServiceAccount:(NSString*)accountName accessKey:(NSString*)accessKey
{
	return [[self alloc] initWithAzureServiceAccount:accountName accessKey:accessKey];
}

@end
