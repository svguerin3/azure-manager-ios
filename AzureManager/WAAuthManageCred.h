//
//  WAAuthManageCred.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WACloudAccessToken.h"
#import "ASIHTTPRequest.h"

@interface WAAuthManageCred : NSObject
{
@private
	BOOL _usesProxy;
	NSError *_authError;
	NSURL *_proxyURL;
	NSString *_token;
	NSString *_accountName;
	NSString *_accessKey;
	NSString *_username;
	NSString *_password;
	WACloudAccessToken *_accessToken;
}

+ (WAAuthManageCred *)credentialWithAzureServiceAccount:(NSString*)accountName accessKey:(NSString*)accessKey;
- (NSURL *)URLWithType:(NSString *)typeStr;
- (ASIHTTPRequest *)authenticatedRequestForType:(NSString *)typeStr withReqBody:(NSString *)dataStr;

@end
