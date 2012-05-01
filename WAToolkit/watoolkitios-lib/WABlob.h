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

extern NSString * const WABlobPropertyKeyBlobType;
extern NSString * const WABlobPropertyKeyCacheControl;
extern NSString * const WABlobPropertyKeyContentEncoding;
extern NSString * const WABlobPropertyKeyContentLanguage;
extern NSString * const WABlobPropertyKeyContentLength;
extern NSString * const WABlobPropertyKeyContentMD5;
extern NSString * const WABlobPropertyKeyContentType;
extern NSString * const WABlobPropertyKeyEtag;
extern NSString * const WABlobPropertyKeyLastModified;
extern NSString * const WABlobPropertyKeyLeaseStatus;
extern NSString * const WABlobPropertyKeySequenceNumber;

@class WABlobContainer;

/**
 A class that represents a Windows Azure Blob. 
 */
@interface WABlob : NSObject

/**
 The name of the blob.
 */
@property (readonly) NSString *name;

/**
 The address that identifies the blob.
 
 @see NSURL
 */
@property (readonly) NSURL *URL;

/**
 A WABlobContainer object representing the blob's container.
 
 @see WABlobContainer
 */
@property (readonly) WABlobContainer *container;

/**
 The properties for the blob.
 */
@property (readonly) NSDictionary *properties;

/**
 Initializes a newly created WABlob with an name and address URL.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 
 @returns The newly initialized WABlob object.
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL;

/**
 Initializes a newly created WABlob with a name, address URL and a container.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param container The container for the blob.
 
 @returns The newly initialized WABlob object.
 
 @see WABlobContainer
 @see NSURL
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL container:(WABlobContainer *)container;

/**
 Initializes a newly created WABlob with a name, address URL, the container and properties.
 
 @param name The name of the blob.
 @param URL The address of the blob.
 @param container The container for the blob.
 @param properties The properties for the blob.
 
 @returns The newly initialized WABlob object.
 
 @see WABlobContainer
 @see NSURL
 */
- (id)initBlobWithName:(NSString *)name URL:(NSString *)URL container:(WABlobContainer *)container properties:(NSDictionary *)properties;

@end
