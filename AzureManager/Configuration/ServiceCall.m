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

#import "ServiceCall.h"
#import <libxml/xmlwriter.h>
#import "WAConfiguration.h"
#import "WACloudAccessToken.h"
#import "WACloudAccessControlClient.h"

@interface ServiceRequest : NSObject {
@private
	NSURLConnection *_connection;
	NSInteger _statusCode;
	NSMutableData *_data;
	void (^_block)(NSInteger statusCode, NSData *response, NSError *error);
}


+ (void)createServiceRequestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod payload:(NSData *)payload contentType:(NSString *)contentType withCompletionHandler:(void (^)(NSInteger statusCode, NSData* response, NSError* error))block;

+ (void)createServiceRequestWithURL:(NSString *)url withCompletionHandler:(void (^)(NSInteger statusCode, NSData *response, NSError *error))block;

@end

@implementation ServiceCall


#define ISO_TIMEZONE_UTC_FORMAT @"Z"
#define ISO_TIMEZONE_OFFSET_FORMAT @"%+02d%02d"

+ (NSString *)iso8601StringFromDate:(NSDate *)date
{
	NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	NSInteger offset = [timeZone secondsFromGMT];
	date = [date dateByAddingTimeInterval:-offset];
	
    static NSDateFormatter* sISO8601 = nil;
	
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
		
		NSMutableString *strFormat = [NSMutableString stringWithString:@"yyyy-MM-dd'T'HH:mm:ss.sss'Z'"];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:strFormat];
    }
	
    return [sISO8601 stringFromDate:date];
}

+ (void)passXmlData:(NSData *)data toXmlCompletionHandler:(void (^)(xmlDocPtr doc, NSError *error))block
{
	const char *baseURL = NULL;
	const char *encoding = NULL;
	
    //NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // SVG COMMENT OUT
	
	xmlDocPtr doc = xmlReadMemory([data bytes], (int)[data length], baseURL, encoding, (XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS)); 
	
	xmlXPathContextPtr xpathCtx = xmlXPathNewContext(doc);
	xmlNodePtr root = xmlDocGetRootElement(doc);
	xpathCtx->node = root;
		
	// anchor at our current node
	if (root != NULL) {
		for (xmlNsPtr nsPtr = root->nsDef; nsPtr != NULL; nsPtr = nsPtr->next) {
			const xmlChar *prefix = nsPtr->prefix;
			if (prefix != NULL) {
				xmlXPathRegisterNs(xpathCtx, prefix, nsPtr->href);
			} else {
				xmlXPathRegisterNs(xpathCtx, (xmlChar *)"_default", nsPtr->href);
			}            
		}
	}
	
	NSString *xpath = @"//_default:div[@id = 'main']";
	xmlXPathObjectPtr xpathObj;
	NSError *error = nil;
	xpathObj = xmlXPathEval((const xmlChar *)[xpath UTF8String], xpathCtx);
	if (xpathObj) {
		xmlNodeSetPtr nodeSet = xpathObj->nodesetval;
		if (nodeSet) {
			for (int index = 0; index < nodeSet->nodeNr; index++) {
                xmlChar *xmlValue = xmlNodeGetContent(nodeSet->nodeTab[index]);
				NSString *value = [NSString stringWithUTF8String:(char*)xmlValue];
				xmlFree(xmlValue);
				value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

				error = [NSError errorWithDomain:@"ACS" 
											code:-1 
										userInfo:[NSDictionary dictionaryWithObject:value forKey:NSLocalizedDescriptionKey]];
				break;
			}
		}
		
		xmlXPathFreeObject(xpathObj);
	}
	
	xmlXPathFreeContext(xpathCtx);
	
	if (error) {
		block(nil, error);
	} else {
		block(doc, nil);
	}
	
	xmlFreeDoc(doc);
}

+ (void)getFromURL:(NSString *)urlStr withCompletionHandler:(void (^)(NSData *data, NSError *error))block
{
	[ServiceRequest createServiceRequestWithURL:urlStr 
						  withCompletionHandler:^(NSInteger statusCode, NSData *response, NSError *error) {
							  if (error) {
								  block(nil, error);
								  return;
							  }
							  
							  block(response, nil);
						  }];
}

+ (void)getFromURL:(NSString *)urlStr withXmlCompletionHandler:(void (^)(xmlDocPtr doc, NSError *error))block
{
	[self getFromURL:urlStr withCompletionHandler:^(NSData *data, NSError *error) {
		if (error) {
			block(nil, error);
			return;
		}
		
		[self passXmlData:data toXmlCompletionHandler:block];
	}];
}

+ (void)getFromURL:(NSString *)urlStr withStringCompletionHandler:(void (^)(NSString *value, NSError *error))block
{
	[self getFromURL:urlStr withXmlCompletionHandler:^(xmlDocPtr doc, NSError *error) {
		 if (error) {
			 block(nil, error);
			 return;
		 }

		 xmlNodePtr root = xmlDocGetRootElement(doc);
         xmlChar *xmlValue = xmlNodeGetContent(root);
		 NSString *value = [NSString stringWithUTF8String:(char*)xmlValue];
		 xmlFree(xmlValue);
         
		 block(value, nil);
	 }];
}

+ (void)getFromURL:(NSString *)urlStr withDictionaryCompletionHandler:(void (^)(NSDictionary *values, NSError *error))block
{
	[self getFromURL:urlStr withXmlCompletionHandler:^(xmlDocPtr doc, NSError *error) {
		 if (error) {
			 block(nil, error);
			 return;
		 }
		 
		 xmlNodePtr root = xmlDocGetRootElement(doc);
		 NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
		 
		 for (xmlNodePtr child = root->children; child; child = child->next) {
			 NSString *name = [NSString stringWithUTF8String:(char *)child->name];
             xmlChar *xmlValue = xmlNodeGetContent(child);
			 NSString *value = [NSString stringWithUTF8String:(char *)xmlValue];
			 xmlFree(xmlValue);
             
			 [dict setObject:value forKey:name];
		 }
		 
		 block(dict, nil);
	 }];
}

+ (void)postXmlToURL:(NSString *)urlStr body:(NSString*)body withCompletionHandler:(void (^)(NSData *data, NSError *error))block
{
	[ServiceRequest createServiceRequestWithURL:urlStr 
									 httpMethod:@"POST" 
										payload:[body dataUsingEncoding:NSUTF8StringEncoding] 
									contentType:@"text/xml" 
						  withCompletionHandler:^(NSInteger statusCode, NSData *response, NSError *error) {
							  if (error) {
								  block(nil, error);
								  return;
							  }
							  
							  block(response, nil);
						  }];
}

+ (void)postXmlToURL:(NSString *)urlStr body:(NSString*)body withXmlCompletionHandler:(void (^)(xmlDocPtr doc, NSError *error))block
{
	[self postXmlToURL:urlStr body:body withCompletionHandler:^(NSData *data, NSError *error) {
		 if (error) {
			 block(nil, error);
			 return;
		 }
		 
		 [self passXmlData:data toXmlCompletionHandler:block];
	 }];
}

+ (void)postXmlToURL:(NSString *)urlStr body:(NSString*)body withDictionaryCompletionHandler:(void (^)(NSDictionary *values, NSError *error))block
{
	[self postXmlToURL:urlStr body:body withXmlCompletionHandler:^(xmlDocPtr doc, NSError *error) {
		if (error) {
			block(nil, error);
			return;
		}
		
		xmlNodePtr root = xmlDocGetRootElement(doc);
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
		
		for (xmlNodePtr child = root->children; child; child = child->next) {
			NSString *name = [NSString stringWithUTF8String:(char*)child->name];
            xmlChar *xmlValue = xmlNodeGetContent(child);
			NSString *value = [NSString stringWithUTF8String:(char*)xmlValue];
            xmlFree(xmlValue);
		
			[dict setObject:value forKey:name];
		}
		
		block(dict, nil);
	}];
}

+ (NSString *)xmlBuilder:(NSString *)rootName objectNamespace:(NSString *)objectNamespace, ...
{
	xmlTextWriterPtr writer;
	xmlBufferPtr buf;
	
	buf = xmlBufferCreate();
    if (buf == NULL) {
        return nil;
    }
	
	writer = xmlNewTextWriterMemory(buf, 0);
	if (buf == NULL) {
		xmlBufferFree(buf);

        return nil;
    }
	
	xmlTextWriterSetIndent(writer, 2);
	
	xmlTextWriterStartDocument(writer, "1.0", "utf-8", "yes");

	NSString *ns = [@"http://schemas.datacontract.org/2004/07/" stringByAppendingString:objectNamespace];

	xmlTextWriterStartElementNS(writer, BAD_CAST nil, BAD_CAST [rootName UTF8String], BAD_CAST [ns UTF8String]);
	xmlTextWriterWriteAttribute(writer, BAD_CAST "xmlns:i", BAD_CAST "http://www.w3.org/2001/XMLSchema-instance");
	
	va_list args;
	NSString *name;
	
	va_start(args, objectNamespace);
	
	while ((name = va_arg(args, NSString*))) {
		id value = va_arg(args, id);
		
		xmlTextWriterStartElement(writer, BAD_CAST [name UTF8String]);
		
		if([value isKindOfClass:[NSNull class]]) {
			xmlTextWriterWriteAttribute(writer, BAD_CAST "xsi:nil", BAD_CAST "true");
		} else {
			xmlTextWriterWriteString(writer, BAD_CAST [[value description] UTF8String]);
		}
		
		xmlTextWriterEndElement(writer);
	}

	xmlTextWriterEndElement(writer); // root
	xmlTextWriterEndDocument(writer);
	
	NSString *str = [NSString stringWithUTF8String:(const char*)buf->content];
	
	xmlFreeTextWriter(writer);
	xmlBufferFree(buf);
	
	return str;
}

@end
	
@implementation ServiceRequest

- (id)initServiceRequestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod payload:(NSData *)payload contentType:(NSString *)contentType withCompletionHandler:(void (^)(NSInteger statusCode, NSData *response, NSError *error))block
{
	if ((self = [super init])) {
		_block = [block copy];
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
		
		[request setHTTPMethod:httpMethod];
		[request setHTTPShouldHandleCookies:NO];
		[request setValue:@"Microsoft ADO.NET Data Services" forHTTPHeaderField:@"User-Agent"];
		
		if (payload) {
			[request setHTTPBody:payload];
			[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
		}
		
		WACloudAccessToken *token = [WACloudAccessControlClient sharedToken];
		if (token) {
			[token signRequest:request];
		}
		
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	
	return self;
}

+ (void)createServiceRequestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod payload:(NSData *)payload contentType:(NSString *)contentType withCompletionHandler:(void (^)(NSInteger statusCode, NSData *response, NSError *error))block
{
	ServiceCall *callObj = [[self alloc] initServiceRequestWithURL:url httpMethod:httpMethod payload:payload contentType:contentType withCompletionHandler:block];
    NSLog(@"createService w/ call: %@", callObj);
}

+ (void)createServiceRequestWithURL:(NSString *)url withCompletionHandler:(void (^)(NSInteger statusCode, NSData *response, NSError *error))block
{
	ServiceCall *callObj = [[self alloc] initServiceRequestWithURL:url httpMethod:@"GET" payload:nil contentType:nil withCompletionHandler:block];
    NSLog(@"createService w/ call: %@", callObj);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	_statusCode = [response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_data) {
		[_data appendData:data];
	} else {
		_data = [data mutableCopy];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	_block(_statusCode, nil, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSError *error = nil;
    
	if (_statusCode >= 300) {
		NSString *msg = [NSString stringWithFormat:@"Invalid HTTP status returned (%d)", _statusCode];
        NSString *detail = nil;
        if (_data) {
            detail = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        }
        
		error = [NSError errorWithDomain:@"com.microsoft.WAToolkitConfig" 
									code:_statusCode 
								userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                          msg, NSLocalizedDescriptionKey, 
                                          detail, NSLocalizedFailureReasonErrorKey, nil]];
		_block(_statusCode, nil, error);
		return;
	}
    
	_block(_statusCode, _data, nil);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		// we only trust our own domain
		NSString *host = challenge.protectionSpace.host;
		NSString *ours = [NSString stringWithFormat:@"%@.cloudapp.net", [WAConfiguration sharedConfiguration].proxyNamespace];
		
		if ([host compare:ours options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end