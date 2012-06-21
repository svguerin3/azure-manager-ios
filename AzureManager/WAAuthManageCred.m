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
    } else if ([typeStr isEqualToString:TYPE_GET_BLOB_PROPERTIES]) {
        urlString = [NSString stringWithFormat:@"http://%@.blob.core.windows.net/?restype=service&comp=properties", _accountName];
    }
    
    NSLog(@"urlStr: %@", urlString);
    return [NSURL URLWithString:urlString];
}

- (ASIHTTPRequest *)authenticatedRequestForType:(NSString *)typeStr
{
    NSURL *serviceURL = [self URLWithType:typeStr];    
    ASIHTTPRequest *authenticatedRequest = [ASIHTTPRequest requestWithURL:serviceURL];
    
    if ([typeStr isEqualToString:TYPE_GET_BLOB_PROPERTIES]) {
        NSString *reqType = @"GET";
        
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
            
        requestString = [NSMutableString stringWithFormat:@"%@\n\n\n%@\n\n%@\n\n\n\n\n\n\n%@\n/%@/", 
                             reqType, @"", @"", headerString, _accountName];
        
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
    }
    
    return authenticatedRequest;
}

@end
