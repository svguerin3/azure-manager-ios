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

- (id)initWithAzureServiceAccount:(NSString*)name accessKey:(NSString*)key subID:(NSString *)subID
{	
	if ((self = [super init]) != nil) {
		_usesProxy = NO;
		_accountName = [name copy];
		_accessKey = [key copy];
        _subID = [subID copy];
	}
	
	return self;
}

+ (WAAuthManageCred *)credentialWithAzureServiceAccount:(NSString*)accountName accessKey:(NSString*)accessKey subID:(NSString *)mySubID 
{
	return [[self alloc] initWithAzureServiceAccount:accountName accessKey:accessKey subID:mySubID];
}

- (void) setMyCertPW:(NSString *)certPW {
    _certPW = [certPW copy];
}

- (NSURL *)URLWithType:(NSString *)typeStr
{
    NSString *urlString = @"";
    if ([typeStr isEqualToString:TYPE_LIST_HOSTED_SERVICES]) {
        urlString = [NSString stringWithFormat:@"https://management.core.windows.net/%@/services/hostedservices", _accountName];
    } else if ([typeStr isEqualToString:TYPE_GET_BLOB_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_BLOB_SERVICE_PROPERTIES]) {
        urlString = [NSString stringWithFormat:@"http://%@.blob.core.windows.net/?restype=service&comp=properties", _accountName];
    } else if ([typeStr isEqualToString:TYPE_GET_TABLE_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_TABLE_SERVICE_PROPERTIES]) {
        urlString = [NSString stringWithFormat:@"http://%@.table.core.windows.net/?restype=service&comp=properties", _accountName];
    } else if ([typeStr isEqualToString:TYPE_GET_QUEUE_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_QUEUE_SERVICE_PROPERTIES]) {
        urlString = [NSString stringWithFormat:@"http://%@.queue.core.windows.net/?restype=service&comp=properties", _accountName];
    }
    
    NSLog(@"urlStr: %@", urlString);
    return [NSURL URLWithString:urlString];
}

- (ASIHTTPRequest *)authenticatedRequestForType:(NSString *)typeStr withReqBody:(NSString *)dataStr 
{
    NSURL *serviceURL = [self URLWithType:typeStr];    
    ASIHTTPRequest *authenticatedRequest = [ASIHTTPRequest requestWithURL:serviceURL];
    
    if ([typeStr isEqualToString:TYPE_LIST_HOSTED_SERVICES]) {
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"azure-cert.pfx"];
        NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:appFile];
        
        if ([PKCS12Data length] > 0) {
            SecIdentityRef certIdentity = [self getIdentity:PKCS12Data];

            // set header(s)
            [authenticatedRequest addRequestHeader:@"x-ms-version" value:@"2012-03-01"];
            
            // set cert
            [authenticatedRequest setClientCertificateIdentity:certIdentity];

            return authenticatedRequest;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We're sorry" 
                                                            message:@"The azure-cert.pfx file was not found. Please use iTunes File Sharing to drag it in for use.  It must be named 'azure-cert.pfx' to work properly in the app." delegate:self cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    } else if ([typeStr isEqualToString:TYPE_GET_BLOB_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_BLOB_SERVICE_PROPERTIES] ||
        [typeStr isEqualToString:TYPE_GET_TABLE_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_TABLE_SERVICE_PROPERTIES] ||
        [typeStr isEqualToString:TYPE_GET_QUEUE_PROPERTIES] || [typeStr isEqualToString:TYPE_SET_QUEUE_SERVICE_PROPERTIES]) {
        NSString *reqType = @"GET";
        
        if ([typeStr isEqualToString:TYPE_SET_BLOB_SERVICE_PROPERTIES] || 
            [typeStr isEqualToString:TYPE_SET_QUEUE_SERVICE_PROPERTIES] ||
            [typeStr isEqualToString:TYPE_SET_TABLE_SERVICE_PROPERTIES]) {
            reqType = @"PUT";
        }
        
        // Construct the date in the right format
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale]; 
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        // construct header string
        NSMutableArray *headers = [NSMutableArray arrayWithCapacity:20];
        [headers addObject:[NSString stringWithFormat:@"x-ms-date:%@", dateString]];
        [headers addObject:@"x-ms-version:2009-09-19"];
        [headers sortUsingSelector:@selector(compare:)];
        NSString *headerString = [headers componentsJoinedByString:@"\n"];
        
        NSMutableString *requestString;
        const NSData *cKey  = [_accessKey dataWithBase64DecodedString];
            
        if ([reqType isEqualToString:@"PUT"]) {
            NSData *contentData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSString *contentLength = contentData ? [NSString stringWithFormat:@"%d", contentData.length] : @"";
            
            NSString *contentMD5;
            
            if (contentData) {
                const NSData *cKey  = [_accountName dataWithBase64DecodedString];
                void* buffer = malloc(CC_SHA256_DIGEST_LENGTH);
                CCHmac(kCCHmacAlgSHA256, [cKey bytes], [cKey length], [contentData bytes], [contentData length], buffer);
                NSData *encodedData = [NSData dataWithBytesNoCopy:buffer length:CC_SHA256_DIGEST_LENGTH freeWhenDone:NO];
                contentMD5 = [encodedData stringWithBase64EncodedData];
                free(buffer);
                
                [authenticatedRequest appendPostData:contentData];
                [authenticatedRequest addRequestHeader:@"content-md5" value:contentMD5];
                [authenticatedRequest setRequestMethod:@"PUT"];
            } else {
                contentMD5 = @"";
            }
            
            // different Auth parameter strings for different APIs
            if ([typeStr isEqualToString:TYPE_SET_TABLE_SERVICE_PROPERTIES]) {
                requestString = [NSMutableString stringWithFormat:@"%@\n%@\n%@\n%@\n/%@/?comp=properties", 
                                 reqType, contentMD5, @"", dateString, _accountName];
            } else {
                requestString = [NSMutableString stringWithFormat:@"%@\n\n\n%@\n%@\n%@\n\n\n\n\n\n\n%@\n/%@/", 
                             reqType, contentLength, contentMD5, @"", headerString, _accountName];
            }
        } else { // GET request
            // different Auth parameter strings for different APIs
            if ([typeStr isEqualToString:TYPE_GET_TABLE_PROPERTIES]) {
                requestString = [NSMutableString stringWithFormat:@"%@\n%@\n%@\n%@\n/%@/?comp=properties", 
                                 reqType, @"", @"", dateString, _accountName];
            } else {
                requestString = [NSMutableString stringWithFormat:@"%@\n\n\n%@\n\n%@\n\n\n\n\n\n\n%@\n/%@/", 
                                 reqType, @"", @"", headerString, _accountName];
            }
        }
        
        // non Table-based APIs need the query parms at the end
        if (![typeStr isEqualToString:TYPE_GET_TABLE_PROPERTIES] && ![typeStr isEqualToString:TYPE_SET_TABLE_SERVICE_PROPERTIES]) {
            NSString *query = [serviceURL query];
            if (query && query.length > 0) {
                NSArray *args = [query componentsSeparatedByString:@"&"];
                
                NSMutableString* q = [NSMutableString stringWithCapacity:100];
                
                for (NSString *arg in [args sortedArrayUsingSelector:@selector(compare:)]) {
                    [q appendString:@"\n"];
                    [q appendString:[arg stringByReplacingOccurrencesOfString:@"=" withString:@":"]];
                }
                
                query = q;
            }
            
            if (query) {
                [requestString appendString:query];
            }
        }
        
        NSLog(@"reqStr: %@", requestString);
        
        // Create the hash
        const NSData *cData = [requestString dataUsingEncoding:NSASCIIStringEncoding];
        
        void* buffer = malloc(CC_SHA256_DIGEST_LENGTH);
        CCHmac(kCCHmacAlgSHA256, [cKey bytes], [cKey length], [cData bytes], [cData length], buffer);
        
        NSData *encodedData = [NSData dataWithBytesNoCopy:buffer length:CC_SHA256_DIGEST_LENGTH freeWhenDone:YES];
        NSString *hash = [encodedData stringWithBase64EncodedData];
        
        NSString *authHeader = [NSString stringWithFormat:@"SharedKey %@:%@", _accountName, hash];
        
        // Set the request headers
        [authenticatedRequest addRequestHeader:@"Authorization" value:authHeader];
        [authenticatedRequest addRequestHeader:@"x-ms-version" value:@"2009-09-19"];
        [authenticatedRequest addRequestHeader:@"x-ms-date" value:dateString];
        
        if ([typeStr isEqualToString:TYPE_GET_TABLE_PROPERTIES]) {
            [authenticatedRequest addRequestHeader:@"DataServiceVersion" value:@"1.0;NetFx"];
            [authenticatedRequest addRequestHeader:@"MaxDataServiceVersion" value:@"1.0;NetFx"];
        }
    }
    
    return authenticatedRequest;
}

- (SecIdentityRef) getIdentity:(NSData *)certData {
    CFDataRef dataRef = (__bridge CFDataRef)certData;
    
    SecIdentityRef myIdentity = NULL;
    SecTrustRef myTrust = NULL;
    
    extractIdentityAndTrust(dataRef, (__bridge CFStringRef)_certPW, &myIdentity, &myTrust);
    
    return myIdentity;
}

OSStatus extractIdentityAndTrust(CFDataRef inCertData, CFStringRef certPW, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;

    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { certPW };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inCertData, options, &items);
    
    if (securityError == 0) {
        NSLog(@"success on validation of certificate!");
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"failed to validate certificate");
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}

@end
