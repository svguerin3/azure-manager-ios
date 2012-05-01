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
 A class that represents a message in a Windows Azure Queue. 
 */
@interface WAQueueMessage : NSObject

/**
 The identifier for the message in the queue.
 */
@property (readonly) NSString *messageId;

/**
 The time the message was inserted into the queue.
 */
@property (readonly) NSString *insertionTime;

/**
 The expieration time for the message in the queue.
 */
@property (readonly) NSString *expirationTime;

/**
 The message's pop receipt.
 The pop receipt is an opaque value that indicates that the message has been retrieved and can be used to delete it.
 */
@property (readonly) NSString *popReceipt;

/**
 The time that the message will next be visible.
 The property is updated when a message is retrieved from the queue. It indicates when a message will become visible again to other clients, if it is not first deleted by the client that retrieved it.
 */
@property (readonly) NSString *timeNextVisible;

/**
 The message text.
 */
@property (copy) NSString *messageText;

/**
 The number of times this message has been dequeued.
 */
@property (readonly) NSInteger dequeueCount;


/**
 Initializes a newly created WAQueueMessage with an identifier, insertion time, experiation time, pop receipt, next visible time and message text.
 
 @param messageId The message identifier.
 @param insertionTime The insertion time for the message.
 @param expirationTime The expiration time for the message.
 @param popReceipt the pop receipt for the message.
 @param timeNextVisible The next visible time for the message.
 @param messageText The message text.
 
 @returns The newly initialized WAQueueMessage object.
 */
- (id)initQueueMessageWithMessageId:(NSString *)messageId insertionTime:(NSString *)insertionTime expirationTime:(NSString *)expirationTime popReceipt:(NSString *)popReceipt timeNextVisible:(NSString *)timeNextVisible messageText:(NSString *)messageText;

/**
 Initializes a newly created WAQueueMessage with an identifier, insertion time, experiation time, pop receipt, next visible time and message text.
 
 @param messageId The message identifier.
 @param insertionTime The insertion time for the message.
 @param expirationTime The expiration time for the message.
 @param popReceipt the pop receipt for the message.
 @param timeNextVisible The next visible time for the message.
 @param messageText The message text.
 @param dequeueCount The dequeue count.
 
 @returns The newly initialized WAQueueMessage object.
 */
- (id)initQueueMessageWithMessageId:(NSString *)messageId insertionTime:(NSString *)insertionTime expirationTime:(NSString *)expirationTime popReceipt:(NSString *)popReceipt timeNextVisible:(NSString *)timeNextVisible messageText:(NSString *)messageText dequeueCount:(NSInteger)dequeueCount;

@end
