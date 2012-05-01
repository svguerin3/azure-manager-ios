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

extern NSString * const WAContainerPropertyKeyEtag;
extern NSString * const WAContainerPropertyKeyLastModified;

/**
 A class that represents a Windows Azure blob container.
 */
@interface WABlobContainer : NSObject

/**
 The name of the container.
 */
@property (copy) NSString *name;

/**
 The address of the container.
 
 @see NSURL
 */
@property (readonly) NSURL *URL;

/**
 The container's metadata.
 */
@property (readonly) NSString *metadata;

/**
 The properties for the container.
 */
@property (readonly) NSDictionary *properties;

/**
 Initializes a newly created WABlobContainer with a name.
 
 @param name The name of the container.
	
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name;

/**
 Initializes a newly created WABlobContainer with a name.
 
 @param name The name of the container.
 @param URL The address of the container.
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL;

/**
 Initializes a newly created WABlobContainer with a name, address and metadata for the container.
 
 @param name The name of the container.
 @param URL The address of the container.
 @param metadata The container's metadata.
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL metadata:(NSString *)metadata;

/**
 Initializes a newly created WABlobContainer with a name, address, metadata for the container.
 
 @param name The name of the container.
 @param URL The address of the container.
 @param metadata The container's metadata.
 @param properties The properties for the container.
 
 @returns The newly initialized WABlobContainer object.
 */
- (id)initContainerWithName:(NSString *)name URL:(NSString *)URL metadata:(NSString *)metadata properties:(NSDictionary *)properties;

@end
