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

/**
 A class that represents a Windows Azure queue.
 */
@interface WAQueue : NSObject

/**
 The name of the queue.
 */
@property (copy) NSString *queueName;

/**
 The address of the queue.
 
 @see NSURL
 */
@property (readonly) NSURL *URL;

/**
 Initializes a newly created WAQueue with a specified name and URL.
 
 @param queueName The name of the queue.
 @param URL The URL for the queue.
 
 @returns The newly initialized WAQueue object.
 */
- (id)initQueueWithName:(NSString *)queueName URL:(NSString *)URL;

@end
