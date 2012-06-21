//
//  WAAuthManageCred.m
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WAAuthManageCred.h"
#import "NSString+URLEncode.h"
#import "WASimpleBase64.h"
#import <stdarg.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>	

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

- (NSURL *)URLWithType:(NSString *)typeStr
{
    NSString *urlString = @"";
    if ([typeStr isEqualToString:TYPE_LIST_HOSTED_SERVICES]) {
        urlString = [NSString stringWithFormat:@"https://management.core.windows.net/%@/services/hostedservices", _accountName];
    }
    
    NSLog(@"urlStr: %@", urlString);
    return [NSURL URLWithString:urlString];
}

- (ASIHTTPRequest *)authenticatedRequestForType:(NSString *)typeStr
{
    NSURL *serviceURL = [self URLWithType:typeStr];    
    ASIHTTPRequest *authenticatedRequest = [ASIHTTPRequest requestWithURL:serviceURL];
    
    return authenticatedRequest;
}

@end
