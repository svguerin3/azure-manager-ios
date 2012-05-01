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
#import <libxml/tree.h>
#import <libxml/xmlstring.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

@interface ServiceCall : NSObject

+ (void)getFromURL:(NSString *)urlStr withCompletionHandler:(void (^)(NSData *data, NSError *error))block;
+ (void)getFromURL:(NSString *)urlStr withXmlCompletionHandler:(void (^)(xmlDocPtr doc, NSError *error))block;
+ (void)getFromURL:(NSString *)urlStr withStringCompletionHandler:(void (^)(NSString *value, NSError *error))block;
+ (void)getFromURL:(NSString *)urlStr withDictionaryCompletionHandler:(void (^)(NSDictionary *values, NSError *error))block;

+ (void)postXmlToURL:(NSString *)urlStr body:(NSString *)body withCompletionHandler:(void (^)(NSData *data, NSError *error))block;
+ (void)postXmlToURL:(NSString *)urlStr body:(NSString *)body withXmlCompletionHandler:(void (^)(xmlDocPtr doc, NSError *error))block;
+ (void)postXmlToURL:(NSString *)urlStr body:(NSString *)body withDictionaryCompletionHandler:(void (^)(NSDictionary *values, NSError *error))block;

+ (NSString *)iso8601StringFromDate:(NSDate *)date;

+ (NSString *)xmlBuilder:(NSString *)rootName objectNamespace:(NSString *)objectNamespace, ... NS_REQUIRES_NIL_TERMINATION;

@end
