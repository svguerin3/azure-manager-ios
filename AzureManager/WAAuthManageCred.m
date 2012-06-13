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

- (NSMutableURLRequest *)authenticatedRequestForType:(NSString *)typeStr
{
    NSURL *serviceURL = [self URLWithType:typeStr];    
    NSMutableURLRequest *authenticatedrequest = [NSMutableURLRequest requestWithURL:serviceURL
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10];
    
    // Construct request
    [authenticatedrequest setHTTPMethod:@"GET"];
    NSMutableArray *headers = [NSMutableArray arrayWithCapacity:20];
    
    // Construct the date in the right format
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale]; 
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];
	NSString *dateString = [dateFormatter stringFromDate:date];
    
    [headers addObject:[NSString stringWithFormat:@"x-ms-date:%@", dateString]];
    [headers addObject:[NSString stringWithFormat:@"%@:%@", @"x-ms-version", X_MS_VERSION_DATE]];
    [headers sortUsingSelector:@selector(compare:)];
	
	NSString *headerString = [headers componentsJoinedByString:@"\n"];        
	NSMutableString *requestString;
    
    const NSData *cKey  = [_accessKey dataWithBase64DecodedString];
	
	//requestString = [NSMutableString stringWithFormat:@"%@\n\n\n%@\n\n%@\n\n\n\n\n\n\n%@\n/%@/", 
	//					 httpMethod, contentLength, contentType ? contentType : @"", headerString, _accountName];
    requestString = [NSMutableString stringWithFormat:@"%@\n\n\n%@\n\n%@\n\n\n\n\n\n\n%@\n/%@/", 
                     	 @"", @"", @"", headerString, _accountName];

	// Create the hash
	const NSData *cData = [requestString dataUsingEncoding:NSASCIIStringEncoding];
	
	void* buffer = malloc(CC_SHA256_DIGEST_LENGTH);
	CCHmac(kCCHmacAlgSHA256, [cKey bytes], [cKey length], [cData bytes], [cData length], buffer);
	
	NSData *encodedData = [NSData dataWithBytesNoCopy:buffer length:CC_SHA256_DIGEST_LENGTH freeWhenDone:YES];
	NSString *hash = [encodedData stringWithBase64EncodedData];
    
    NSLog(@"Request string: %@", requestString);
    NSLog(@"Request hash: %@", hash);
    
	// Append to the Authorization Header
	NSString *authHeader = [NSString stringWithFormat:@"SharedKey %@:%@", _accountName, hash];
	
	// Set the request headers
	[authenticatedrequest addValue:dateString forHTTPHeaderField:@"x-ms-date"];
	[authenticatedrequest addValue:X_MS_VERSION_DATE forHTTPHeaderField:@"x-ms-version"];
	[authenticatedrequest addValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    return authenticatedrequest;
}

@end
