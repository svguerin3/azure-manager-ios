/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

@class WACloudAccessToken;

/*
 When used with the proxy service, the authentication delegate returns indication whether the login was successful. 
 */
@protocol WAAuthenticationDelegate <NSObject>

/**
 Sent to the delegate when the login succeeds for the proxy service.
 */
- (void)loginDidSucceed;

/**
 Sent to the delegate when the login succeeds for the proxy service.
 
 @param error An NSError object describing the error that occurred.
 */
- (void)loginDidFailWithError:(NSError *)error;


@end

/** 
 A class that represents an authentication object that can be passed to the WACloudStorageClient. The class can be initialized using a Windows Azure account name and key, or with a proxy server URL, username, and password. 
 
 @see WACloudStorageClient
 */
@interface WAAuthenticationCredential : NSObject <NSXMLParserDelegate>
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
	NSString *_tableServiceURL;
	NSString *_blobServiceURL;
	WACloudAccessToken *_accessToken;
}

/**
 Determines whether this authentication credential uses a proxy service.
 The default value is NO.
 */
@property (readonly) BOOL usesProxy;

/**
 The URL of the proxy service.
 
 @see NSURL
 */
@property (nonatomic, readonly) NSURL *proxyURL;

/**
 The seesion token returned from authentication with the proxy service.
 */
@property (nonatomic, readonly) NSString *token;

/**
 The account name for Windows Azure storage or nil if not authenticating directly.
 */
@property (nonatomic, readonly) NSString *accountName;

/**
 The account access key for Windows Azure storage or nil if not authenticating directly.
 */
@property (nonatomic, readonly) NSString *accessKey;

/**
 The URL of the table service endpoint, if authenticating with a proxy service.
 */
@property (nonatomic, readonly) NSString *tableServiceURL;

/**
 The URL of the blob service endpoint, if authenticating with a proxy service.
 */
@property (nonatomic, readonly) NSString *blobServiceURL;

/**
 Initializes a newly created WAAuthenticationCredential with a specified account name and access key obtained from the Windows Azure portal.
 
 @param accountName The Windows Azure storage account name.
 @param accessKey The access key for the given account.
 
 @returns The newly initialized WAAuthenticationCredential object.
 */
+ (WAAuthenticationCredential *)credentialWithAzureServiceAccount:(NSString *)accountName accessKey:(NSString *)accessKey;

/**
 Initializes a newly created WAAuthenticationCredential with a specified proxy URL, the user name and password for the proxy service, and an NSError object that will contain the error information if the authentication fails.
 
 @param proxyURL The URL address of the proxy service.
 @param user The user name for the proxy service.
 @param password The password for the proxy service.
 @param returnError An NSError object that will contain the error if the authentication fails.
 
 @returns The newly initialized WAAuthenticationCredential object.
 
 @see NSURL
 @see NSError
 */
+ (WAAuthenticationCredential *)authenticateCredentialSynchronousWithProxyURL:(NSURL *)proxyURL user:(NSString *)user password:(NSString *)password error:(NSError **)returnError;

/**
 Initializes a newly created WAAuthenticationCredential with a specified proxy URL, the table service URL, the blob service URL, the user name and password for the proxy service, and an NSError object that will contain the error information if the authentication fails.
 
 @param proxyURL The URL address of the proxy service.
 @param tablesURL The URL address of the table service.
 @param blobsURL The URL address of the blob service.
 @param user The user name for the proxy service.
 @param password The password for the proxy service.
 @param returnError An NSError object that will contain the error if the authentication fails.
 
 @returns The newly initialized WAAuthenticationCredential object.
 
 @see NSURL
 @see NSError
 */
+ (WAAuthenticationCredential *)authenticateCredentialSynchronousWithProxyURL:(NSURL *)proxyURL tableServiceURL:(NSURL *)tablesURL blobServiceURL:(NSURL *)blobsURL user:(NSString *)user password:(NSString *)password error:(NSError **)returnError;


/**
 Initializes a newly created WAAuthenticationCredential with a specified proxy URL, the user name and password for the proxy service, and a delegate to callback when authentication completes.
 
 @param proxyURL The URL address of the proxy service.
 @param user The user name for the proxy service.
 @param password The password for the proxy service.
 @param delegate The delegate to use.
 
 @returns The newly initialized WAAuthenticationCredential object.
 
 @see NSURL
 @see WAAuthenticationDelegate
 */
+ (WAAuthenticationCredential *)authenticateCredentialWithProxyURL:(NSURL *)proxyURL user:(NSString *)user password:(NSString *)password delegate:(id<WAAuthenticationDelegate>)delegate;

/**
 Initializes a newly created WAAuthenticationCredential with a specified proxy URL, the user name and password for the proxy service.
 
 @param proxyURL The URL address of the proxy service.
 @param user The user name for the proxy service.
 @param password The password for the proxy service.
 @param block A block object that is called with the authentication completes. The block will contain an NSError
 
 @returns The newly initialized WAAuthenticationCredential object.
 
 @see NSURL
 @see NSError
 */
+ (WAAuthenticationCredential *)authenticateCredentialWithProxyURL:(NSURL *)proxyURL user:(NSString *)user password:(NSString *)password withCompletionHandler:(void (^)(NSError *error))block;

/**
 Initializes a newly created WAAuthenticationCredential with a specified proxy URL and access token. The access token is the result of using Windows Azure Access Control Service.
 
 @param proxyURL The URL address of the proxy service.
 @param accessToken The WACloudAccessToken used to authenticate.
 
 @returns The newly initialized WAAuthenticationCredential object.
 
 @see NSURL
 @see WACloudAccessToken
 */
+ (WAAuthenticationCredential *)authenticateCredentialWithProxyURL:(NSURL *)proxyURL accessToken:(WACloudAccessToken *)accessToken;

@end
