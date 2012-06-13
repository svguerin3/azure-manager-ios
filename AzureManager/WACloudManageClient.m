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
    NSMutableURLRequest *myReq = [_credential authenticatedRequestForType:TYPE_LIST_HOSTED_SERVICES];
    NSURLConnection *myConn = [[NSURLConnection alloc] initWithRequest:myReq delegate:self startImmediately:YES];
    [myConn start]; 
    
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"got into canAuth, method: %@", protectionSpace.authenticationMethod);
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    SecTrustRef trustRef = [[challenge protectionSpace] serverTrust];
    SecTrustEvaluate(trustRef, NULL);
    CFIndex count = SecTrustGetCertificateCount(trustRef); 
    
    for (CFIndex i = 0; i < count; i++)
    {
        SecCertificateRef certRef = SecTrustGetCertificateAtIndex(trustRef, i);
        CFStringRef certSummary = SecCertificateCopySubjectSummary(certRef);
        CFDataRef certData = SecCertificateCopyData(certRef);
        NSLog(@"certSummary: %@", certSummary);
        NSLog(@"sha1: %@", [self sha1:(__bridge NSData *)certData]);
        
        
        
        
        OSStatus securityError = errSecSuccess;
        CFStringRef password = CFSTR("Password");
        const void *keys[] =   { kSecImportExportPassphrase };
        const void *values[] = { password };
        CFDictionaryRef optionsDictionary = CFDictionaryCreate(
                                                               NULL, keys,
                                                               values, 1,
                                                               NULL, NULL);  // 6
        
        
        CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
        securityError = SecPKCS12Import(certData,
                                        optionsDictionary,
                                        &items);                    // 7
        
        
        //
        if (securityError == 0) {                                   // 8
            CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
            const void *tempIdentity = NULL;
            tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                                 kSecImportItemIdentity);
            SecIdentityRef outIdentity = (SecIdentityRef)tempIdentity;
        } else {
            NSLog(@"security error");
        }
    }
    
    NSLog(@"got into didReceiveAuthChallenge, host: %@", challenge.protectionSpace.host);
    NSArray *trustedHosts = [NSArray arrayWithObject:@"management.core.windows.net"];
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([trustedHosts containsObject:challenge.protectionSpace.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

// get thumbprint
-(NSString*)sha1:(NSData*)certData {
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH]; 
    CC_SHA1(certData.bytes, certData.length, sha1Buffer); 
    NSMutableString *fingerprint = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 3]; 
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i) 
        [fingerprint appendFormat:@"%02x ",sha1Buffer[i]]; 
    return [fingerprint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
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
