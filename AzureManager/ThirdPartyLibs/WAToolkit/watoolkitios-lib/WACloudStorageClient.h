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

@class WAAuthenticationCredential;
@class WABlob;
@class WABlobContainer;
@class WATableEntity;
@class WATable;
@class WAQueueMessage;
@class WATableFetchRequest;
@class WAResultContinuation;

@protocol WACloudStorageClientDelegate;

/**
 The cloud storage client is used to invoke operations on, and return data from, Windows Azure storage. 
 */
@interface WACloudStorageClient : NSObject
{
@private
	WAAuthenticationCredential* _credential;
	id<WACloudStorageClientDelegate> _delegate;
}

///---------------------------------------------------------------------------------------
/// @name Setting the Delegate
///---------------------------------------------------------------------------------------

/**
 The delegate is sent messages when content is loaded or errors occur from Windows Azure storage.
 */
@property (assign) id<WACloudStorageClientDelegate> delegate;

///---------------------------------------------------------------------------------------
/// @name Managing Certificates
///---------------------------------------------------------------------------------------

/**
 Ignores any ssl errors from the given host. This is useful when using a self signed certificate.
 
 @param host The host to ignore errors.
 */
+ (void)ignoreSSLErrorFor:(NSString *)host;

#pragma mark - Blob Operations
///---------------------------------------------------------------------------------------
/// @name Blob Operations
///---------------------------------------------------------------------------------------

/**
 Fetch a list of blob containers asynchronously. 
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. There could be a limit to the number of containers that are returned. If you have many containers you may want to use the continuation version of fetching the containers.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobContainers:
 */
- (void)fetchBlobContainers;

/**
 Fetch a list of blob containers asynchronously using a block.
 
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will contain the array of WABlobContainer objects or an error if one occurs. There could be a limit to the number of containers that are returned. If you have many containers you may want to use the continuation version of fetching the containers.
 
 @see WABlobContainer
 */
- (void)fetchBlobContainersWithCompletionHandler:(void (^)(NSArray *containers, NSError *error))block;

/**
 Fetch a list of blob containers asynchronously using continuation.
 
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of containers to reuturn for this fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate set for the client.
 
 @see WAResultContinuation
 @see WACloudStorageClient#delegate
 @see WACloudStorateClientDelegate#storageClient:didFetchBlobContainers:withResultContinuation:
 */
- (void)fetchBlobContainersWithContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult;

/**
 Fetch a list of blob containers asynchronously using continuation with a block.
 
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of containers to reuturn for this fetch.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will contain the array of WABlobContainer objects or an error if one occurs. The WAResultContinuation returned in the block can be used to call this method again to get the next set of containers.
 
 @see WAResultContinuation
 */
- (void)fetchBlobContainersWithContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult usingCompletionHandler:(void (^)(NSArray *containers, WAResultContinuation *resultContinuation, NSError *error))block;

/**
 Fetch a blob container by name asynchronously.
 
 @param containerName The name of the container to fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate set for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobContainer:
 */
- (void)fetchBlobContainerNamed:(NSString *)containerName;

/**
 Fetch a blob container by name asynchronously using a block.
 
 @param containerName The name of the container to fetch.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will contain the WABlobContainer object or an error if one occurs.
 
 @see WABlobContainer
 */
- (void)fetchBlobContainerNamed:(NSString *)containerName withCompletionHandler:(void (^)(WABlobContainer *container, NSError *error))block;

/**
 Adds a named blob container asynchronously.

 @param containerName The container name to add.

 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the delegate set for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didAddBlobContainerNamed:
 */
- (BOOL)addBlobContainerNamed:(NSString *)containerName;

/**
 Adds a named blob container asynchronously using a block.
	
 @param containerName The container name to add.
 @param block A block object called with the results of the add.
	
 @returns Returns if the request was sent or not.
 
 @description The method will run asynchronously and will call back through the block. The block wil contain an error if one occurred or nil.
 
 @see NSError
 */
- (BOOL)addBlobContainerNamed:(NSString *)containerName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes a specified blob container asynchronously.
	
 @param container The container to delete.
	
 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the delegate set for the client.
 
 @see WABlobContainer
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobContainer:
 */
- (BOOL)deleteBlobContainer:(WABlobContainer *)container;

/**
 Deletes a specified blob container asynchronously using a block.
 
 @param container The container to delete.
 @param block A block object called with the results of the delete.
	
 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the block. The block will return an error if there was an error or nil if not.
 
 @see WABlobContainer
 */
- (BOOL)deleteBlobContainer:(WABlobContainer *)container withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes a specified named blob container asynchronously.
	
 @param containerName The name of the container to delete.
	
 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the delegate set for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteBlobContainerNamed:
 */
- (BOOL)deleteBlobContainerNamed:(NSString *)containerName;

/**
 Deletes a specified named blob container asynchronously with a block.
	
 @param containerName The name of the container to delete.
 @param block A block object called with the results of the delete.
	
 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the block. The block will return an error if there was an error or nil if not.
 
 @see NSError
 */
- (BOOL)deleteBlobContainerNamed:(NSString *)containerName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Fetch the blobs for the specified blob container asynchronously.
 
 @param container The container for the blobs to fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. There could be a limit to the number of blobs that are returned. If you have many blobs, you may want to use the continuation version of fetching the blobs.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobs:inContainer:
 @see WABlobContainer
 @see fetchBlobsWithContinuation:resultContinuation:maxResult:
 */
- (void)fetchBlobs:(WABlobContainer *)container;

/**
 Fetch the blobs for the specified blob container asynchronously with a block.
 
 @param container The container for the blobs to fetch.
 @param block A block object called with the results of the delete.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an array of WABlob objects or an error if the request failed. There could be a limit to the number of blobs that are returned. If you have many blobs, you may want to use the continuation version of fetching the blobs.
 
 @see WABlobContainer
 @see WABlob
 @see fetchBlobsWithContinuation:resultContinuation:maxResult:usingCompletionHandler:
 */
- (void)fetchBlobs:(WABlobContainer *)container withCompletionHandler:(void (^)(NSArray *blobs, NSError *error))block;

/**
 Fetch the blobs for the specified blob container asynchronously using continuation.
	
 @param container The container for the blobs to fetch.
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of blobs to reuturn for this fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. The continuation token contains the next marker to use or nil if this is the first request.
 
 @see WAResultContinuation
 @see WABlobContainer
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobs:inContainer:withResultContinuation:
 */
- (void)fetchBlobsWithContinuation:(WABlobContainer *)container resultContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult;

/**
 Fetch the blobs for the specified blob container asynchronously using continuation with a block.
 
 @param container The container for the blobs to fetch.
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of blobs to reuturn for this fetch.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will return an arry of WABlob objects if the request succeeds or an error if it fails. The result continuation can be used to make requests for the next set of blobs in the contianer.
 
 @see WABlobContainer
 @see WAResultContinuation
 */
- (void)fetchBlobsWithContinuation:(WABlobContainer *)container resultContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult usingCompletionHandler:(void (^)(NSArray *blobs, WAResultContinuation *resultContinuation, NSError *error))block;

/**
 Fetch the blob data for the specified blob asynchronously.
	
 @param blob The blob to fetch the data.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobData:blob:
 @see WABlob
 @see NSData
 */
- (void)fetchBlobData:(WABlob *)blob;

/*! Returns the binary data (NSData) object for the specified blob. */
/**
 Fetch the blob data for the specified blob asynchronously.
	
 @param blob The blob to fetch the data.
 @param block A block object called with the results of the fetch. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with the data for the blob if the request succeeds or an error if the request fails.
 
 @see WABlob
 @see NSData
 */
- (void)fetchBlobData:(WABlob *)blob withCompletionHandler:(void (^)(NSData *data, NSError *error))block;

/**
 Fetch the blob data for the specified url asynchronously.
 
 @param blob The blob to fetch the data.
 
 @returns Returns if the request was sent or not.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. This method will only run when you are using the proxy service. 
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchBlobData:URL:
 @see NSURL
 @see NSData
 */
- (BOOL)fetchBlobDataFromURL:(NSURL *)URL;

/*! Returns the binary data (NSData) object for the specified blob. */
/**
 Fetch the blob data for the specified blob asynchronously.
 
 @param blob The blob to fetch the data.
 @param block A block object called with the results of the fetch. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with the data for the blob if the request succeeds or an error if the request fails. This method will only run when you are using the proxy service.
 
 @see NSURL
 @see NSData
 */
- (BOOL)fetchBlobDataFromURL:(NSURL *)URL withCompletionHandler:(void (^)(NSData *data, NSError *error))block;

/**
 Adds a new blob to a container asynchronously, given the name of the blob, binary data for the blob, and content type.
	
 @param container The container to use to add the blob.
 @param blobName The name of the blob.
 @param contentData The data for the blob.
 @param contentType The content type for the blob.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClient#storageClient:didAddBlobToContainer:blobName:
 @see WABlobContainer
 */
- (void)addBlobToContainer:(WABlobContainer *)container blobName:(NSString *)blobName contentData:(NSData *)contentData contentType:(NSString*)contentType;

/*! Adds a new blob to a container, given the name of the blob, binary data for the blob, and content type. */
/**
 Adds a new blob to a container asynchronously, given the name of the blob, binary data for the blob, and content type with a block.
	
 @param container The container to use to add the blob.
 @param blobName The name of the blob to add.
 @param contentData The content of the blob to add.
 @param contentType The type of content to add.
 @param block A block object called with the results of the add. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called an error if the request fails, otherwise the error object will be nil.
 
 @see WABlobContainer
 */
- (void)addBlobToContainer:(WABlobContainer *)container blobName:(NSString *)blobName contentData:(NSData *)contentData contentType:(NSString *)contentType withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes a given blob asynchronously.
	
 @param blob The blob to delete
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteBlob:
 @see WABlob
 */
- (void)deleteBlob:(WABlob *)blob;

/**
 Deletes a blob asynchronously using a block.
 
 @param blob the blob to delete.
 @param block A block object called with the results of the delete.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WABlob
 */
- (void)deleteBlob:(WABlob *)blob withCompletionHandler:(void (^)(NSError *error))block;

#pragma mark - Queue Operations
///---------------------------------------------------------------------------------------
/// @name Queue Operations
///---------------------------------------------------------------------------------------

/**
 Fetch a list of queues asynchronously.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchQueues:
 */
- (void)fetchQueues;

/**
 Fetch a list of queues asynchronously using a block.
 
 @param block A block object called with the results of the fetch. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with a list of WAQueue objects or an error if the request fails, otherwise the error object will be nil.
 
 @see WAQueue
 */
- (void)fetchQueuesWithCompletionHandler:(void (^)(NSArray *queues, NSError *error))block;

/*! Returns a list of queues. */
/**
 Fetch a list of queues asynchronously with a result continuation.
	
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of queues to reuturn for this fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. The result continuation can be nil or conatin the marker to fetch the next set of queues from a previous request.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchQueues:withResultContinuation:
 @see WAResultContinuation
 */
- (void)fetchQueuesWithContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult;

/**
 Fetch a list of queues asynchronously with a result continuation using a block.
	
 @param resultContinuation The result continuation to use for this fetch request.
 @param maxResult The max number of queues to reuturn for this fetch.
 @param block A block object called with the results of the fetch. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will return an arry of WAQueue objects if the request succeeds or an error if it fails. The result continuation can be used to make requests for the next set of blobs in the contianer.
 
 @see WAResultContinuation
 */
- (void)fetchQueuesWithContinuation:(WAResultContinuation *)resultContinuation maxResult:(NSInteger)maxResult usingCompletionHandler:(void (^)(NSArray *queues, WAResultContinuation *resultContinuation, NSError *error))block;

/**
 Adds a queue asynchronously, given a specified queue name.
	
 @param queueName The name of the queue to add.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didAddQueueNamed:
 */
- (void)addQueueNamed:(NSString *)queueName;

/*! Adds a queue, given a specified queue name.  Returns error if the queue already exists, or where the name is an invalid format.*/
/**
 Adds a queue asynchronously, given a specified queue name using a block.
 
 @param queueName The name of the queue to add.
 @param block A block object called with the results of the add. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 */
- (void)addQueueNamed:(NSString *)queueName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes a queue asynchronously, given a specified queue name.
 
 @param queueName The name of the queue to delete.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteQueueNamed:
 */
- (void)deleteQueueNamed:(NSString *)queueName;

/**
 Deletes a queue asynchronously, given a specified queue name using a block.
 
 @param queueName The name of the queue to delete.
 @param block A block object called with the results of the delete. 
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 */
- (void)deleteQueueNamed:(NSString *)queueName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Fetch messages asynchronously for a given queue name.
	
 @param queueName The name of the queue to get messages.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchQueueMessages:
 */
- (void)fetchQueueMessages:(NSString *)queueName;

/**
 Fetch messages asynchronously for a given queue name using a block.
 
 @param queueName The name of the queue to get messages.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with a list of WAQueueMessage objects or an error if the request fails, otherwise the error object will be nil.
 
 @see WAQueueMessage
 */
- (void)fetchQueueMessages:(NSString *)queueName withCompletionHandler:(void (^)(NSArray *messages, NSError *error))block;

/**
 Fetch a single message asynchronously from the specified queue.
	
 @param queueName The name of the queue.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchQueueMessage:
 */
- (void)fetchQueueMessage:(NSString *)queueName;

/**
 Fetch a single message asynchronously from the specified queue using a block.
	
 @param queueName The name of the queue.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with a WAQueueMessage object or an error if the request fails, otherwise the error object will be nil.
 
 @see WAQueueMessage
 */
- (void)fetchQueueMessage:(NSString *)queueName withCompletionHandler:(void (^)(WAQueueMessage *message, NSError *error))block;

/**
 Fetch a batch of messages asynchronously from the specified queue.
	
 @param queueName The name of the queue.
 @param fetchCount The number of messages to fetch.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. The max number of messages that will be returned is 32.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchQueueMessages:
 */
- (void)fetchQueueMessages:(NSString *)queueName fetchCount:(NSInteger)fetchCount;

/**
 Fetch a batch of messages asynchronously from the specified queue using a block.
 
 @param queueName The name of the queue.
 @param fetchCount The number of messages to fetch.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an array of WAQueueMessage object or an error if the request fails, otherwise the error object will be nil.
 
 @see WAQueueMessage
 */
- (void)fetchQueueMessages:(NSString *)queueName fetchCount:(NSInteger)fetchCount withCompletionHandler:(void (^)(NSArray *messages, NSError *error))block;

/**
 Peeks a single message from the specified queue asynchronously.
 
 @param queueName The name of the queue.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. Peek is like fetch, but the message is not marked for removal.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didPeekQueueMessage:
 */
- (void)peekQueueMessage:(NSString *)queueName;

/**
 Peeks a single message from the specified queue asynchronously using a block.
	
 @param queueName The name of the queue.
 @param block A block object called with the results of the peek.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with a WAQueueMessage object or an error if the request fails, otherwise the error object will be nil. Peek is like fetch, but the message is not marked for removal.
 
 @see WAQueueMessage
 */
- (void)peekQueueMessage:(NSString *)queueName withCompletionHandler:(void (^)(WAQueueMessage *message, NSError *error))block;

/**
 Peeks a batch of messages from the specified queue asynchronously.
	
 @param queueName The name of the queue.
 @param fetchCount The number of messages to return.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. Peek is like fetch, but the message is not marked for removal.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didPeekQueueMessages:
 */
- (void)peekQueueMessages:(NSString *)queueName fetchCount:(NSInteger)fetchCount;

/**
 Peeks a batch of messages from the specified queue asynchronously using a block.
 
 @param queueName The name of the queue.
 @param fetchCount The number of messages to return.
 @param block A block object called with the results of the peek.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an array of WAQueueMessage object or an error if the request fails, otherwise the error object will be nil. Peek is like fetch, but the message is not marked for removal.
 
 @see WAQueueMessage
 */
- (void)peekQueueMessages:(NSString *)queueName fetchCount:(NSInteger)fetchCount withCompletionHandler:(void (^)(NSArray *messages, NSError *error))block;

/**
 Deletes a message asynchronously, given a specified queue name and queueMessage.
	
 @param queueMessage The message to delete.
 @param queueName The name of the queue that owns the message.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteQueueMessage:queueName:
 @see WAQueueMessage
 */
- (void)deleteQueueMessage:(WAQueueMessage *)queueMessage queueName:(NSString *)queueName;

/**
 Deletes a message asynchronously, given a specified queue name and queueMessage using a block.
 
 @param queueMessage The message to delete.
 @param queueName The name of the queue that owns the message.
 @param block A block object called with the results of the peek.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WAQueueMessage
 */
- (void)deleteQueueMessage:(WAQueueMessage *)queueMessage queueName:(NSString *)queueName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Adds a message into a queue asynchronously, given a specified queue name and message.
	
 @param message The message to add.
 @param queueName The name of the queue to add the message.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didAddMessageToQueue:queueName:
 */
- (void)addMessageToQueue:(NSString *)message queueName:(NSString *)queueName;

/**
 Adds a message into a queue asynchronously, given a specified queue name and message.
 
 @param message The message to add.
 @param queueName The name of the queue to add the message.
 @param block A block object called with the results of the add.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 */
- (void)addMessageToQueue:(NSString *)message queueName:(NSString *)queueName withCompletionHandler:(void (^)(NSError *error))block;

#pragma mark - Table Operations
///---------------------------------------------------------------------------------------
/// @name Table Operations
///---------------------------------------------------------------------------------------

/**
 Fetch a list of tables asynchronously.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchTables:
 */
- (void)fetchTables;

/**
 Fetch a list of tables asynchronously using a block.
 
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an arrary of NSString objects that are the table names or an error if the request fails, otherwise the error object will be nil.
 */
- (void)fetchTablesWithCompletionHandler:(void (^)(NSArray *tables, NSError *error))block;

/**
 Fetch a list of tables asynchronously.
 
 @param resultContinuation The result continuation to use for this fetch request.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchTables:withResultContinuation:
 @see WAResultContinuation
 */
- (void)fetchTablesWithContinuation:(WAResultContinuation *)resultContinuation;

/**
 Fetch a list of tables asynchronously.
 
 @param resultContinuation The result continuation to use for this fetch request.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an arrary of NSString objects that are the table names or an error if the request fails, otherwise the error object will be nil. The result continuation can be used to make requests for the next set of blobs in the contianer.
 
 @see WAResultContinuation
 */
- (void)fetchTablesWithContinuation:(WAResultContinuation *)resultContinuation usingCompletionHandler:(void (^)(NSArray *tables, WAResultContinuation *resultContinuation, NSError *error))block;

/**
 Creates a new table asynchronously with a specified name.
	
 @param newTableName The new table name.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didCreateTableNamed:
 */
- (void)createTableNamed:(NSString *)newTableName;

/**
 Creates a new table asynchronously with a specified name.
 
 @param newTableName The new table name.
 @param block A block object called with the results of the create.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 */
- (void)createTableNamed:(NSString *)newTableName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes a specifed table asynchronously.
 
 @param tableName The name of the table to delete.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteTableNamed:
 */
- (void)deleteTableNamed:(NSString *)tableName;

/**
 Deletes a specifed table asynchronously using a block.
 
 @param tableName The name of the table to delete.
 @param block A block object called with the results of the delete.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 */
- (void)deleteTableNamed:(NSString *)tableName withCompletionHandler:(void (^)(NSError *error))block;

/**
 Fetches the entities for a given table asynchronously.
	
 @param fetchRequest The request to use to fetch the entities.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchEntities:fromTableNamed:
 @see WATableFetchRequest
 */
- (void)fetchEntities:(WATableFetchRequest *)fetchRequest;

/**
 Fetches the entities for a given table asynchronously using a block.
	
 @param fetchRequest The request to use to fetch the entities.
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an arrary of WATableEntity objects that are the table names or an error if the request fails, otherwise the error object will be nil.
 
 @see WATableEntity
 @see WATableFetchRequest
 */
- (void)fetchEntities:(WATableFetchRequest *)fetchRequest withCompletionHandler:(void (^)(NSArray *entities, NSError *error))block;

/**
 Fetches the entities for a given table asynchronously using a result continuation.
 
 @param fetchRequest The request to use to fetch the entities. 
 
 @discussion The method will run asynchronously and will call back through the delegate for the client. The fetch request contains the result continuation to use for this fetch request.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didFetchEntities:fromTableNamed:withResultContinuation:
 @see WATableFetchRequest
 */
- (void)fetchEntitiesWithContinuation:(WATableFetchRequest *)fetchRequest;

/**
 Fetches the entities for a given table asynchronously using a result continuation and block.
 
 @param fetchRequest The request to use to fetch the entities. 
 @param block A block object called with the results of the fetch.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an arrary of WATableEntity objects that are the table names or an error if the request fails, otherwise the error object will be nil. The result continuation can be used to make requests for the next set of blobs in the contianer.
 
 @see WAFetchRequest
 @see WATableEntity
 */
- (void)fetchEntitiesWithContinuation:(WATableFetchRequest *)fetchRequest usingCompletionHandler:(void (^)(NSArray *entities, WAResultContinuation *resultContinuation, NSError *error))block;

/**
 Inserts a new entity into an existing table asynchronously.
	
 @param newEntity The new entity to insert.
	
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didInsertEntity:
 @see WATableEntity
 */
- (BOOL)insertEntity:(WATableEntity *)newEntity;

/*! Inserts a new entity into an existing table. */
/**
 Inserts a new entity into an existing table asynchronously using a block.
 
 @param newEntity The new entity to insert.
 @param block A block object called with the results of the insert.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WATableEntity
 */
- (BOOL)insertEntity:(WATableEntity *)newEntity withCompletionHandler:(void (^)(NSError *error))block;

/**
 Updates an existing entity within a table asynchronously.
	
 @param existingEntity The entity to update.
	
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didUpdateEntity:
 @see WATableEntity
 */
- (BOOL)updateEntity:(WATableEntity *)existingEntity;


/**
 Updates an existing entity within a table asynchronously using a block.
 
 @param existingEntity The entity to update.
 @param block A block object called with the results of the insert.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WATableEntity
 */
- (BOOL)updateEntity:(WATableEntity *)existingEntity withCompletionHandler:(void (^)(NSError *error))block;

/**
 Merges an existing entity within a table asynchronously.
 
 @param existingEntity The entity to merge.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didMergeEntity:
 @see WATableEntity
 */
- (BOOL)mergeEntity:(WATableEntity *)existingEntity;

/**
 Merges an existing entity within a table asynchronously using a block.
 
 @param existingEntity The entity to merge.
 @param block A block object called with the results of the merge.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WATableEntity
 */
- (BOOL)mergeEntity:(WATableEntity *)existingEntity withCompletionHandler:(void (^)(NSError *error))block;

/**
 Deletes an existing entity within a table asynchronously.
 
 @param existingEntity The entity to delete.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the delegate for the client.
 
 @see WACloudStorageClient#delegate
 @see WACloudStorageClientDelegate#storageClient:didDeleteEntity:
 @see WATableEntity
 */
- (BOOL)deleteEntity:(WATableEntity *)existingEntity;

/**
 Deletes an existing entity within a table asynchronously using a block.
 
 @param existingEntity The entity to delete.
 @param block A block object called with the results of the delete.
 
 @returns Returns if the request was sent successfully.
 
 @discussion The method will run asynchronously and will call back through the block. The block will be called with an error if the request fails, otherwise the error object will be nil.
 
 @see WATableEntity
 */
- (BOOL)deleteEntity:(WATableEntity *)existingEntity withCompletionHandler:(void (^)(NSError *error))block;

///---------------------------------------------------------------------------------------
/// @name Creating and Initializing Clients
///---------------------------------------------------------------------------------------

/**
 Create a storage client initialized with the given credential.
	
 @param credential The credentials for Windows Azure storage. 
	
 @returns The newly initialized WACloudStorageClient object.
 */
+ (WACloudStorageClient *)storageClientWithCredential:(WAAuthenticationCredential *)credential;


@end

/**
 The WACloudStorageClientDelegate protocol defines methods that a delegate of WACloudStorageClient object can optionally implement when a request is made.
 */
@protocol WACloudStorageClientDelegate <NSObject>

@optional

///---------------------------------------------------------------------------------------
/// @name Request Completion
///---------------------------------------------------------------------------------------

/**
 Sent if a URL request failed.
	
 @param client The client that sent the request.
 @param request The request that failed.
 @param error The error that occurred.
 */
- (void)storageClient:(WACloudStorageClient *)client didFailRequest:(NSURLRequest*)request withError:(NSError *)error;

///---------------------------------------------------------------------------------------
/// @name Blob Request Completion
///---------------------------------------------------------------------------------------

/**
 Sent when the client successfully returns a list of blob containers.
	
 @param client The client that sent the request.
 @param containers The array of WABlobContainer objects returned from the request.
 
 @see WABlobContainer
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobContainers:(NSArray *)containers;

/**
 Sent when the client successfully returns a list of blob containers and the result continuation that you can use when making future requests to get the next set of containers. 
	
 @param client The client that sent the request.
 @param containers The array of WABlobContainer objects returned from the request.
 @param resultContinuation The result continuation that contains the marker to use for the next request.
 
 @see WABlobContainer
 @see WAResultContinuation
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobContainers:(NSArray *)containers withResultContinuation:(WAResultContinuation *)resultContinuation;

/**
 Sent when the client successfully returns a blob container.
	
 @param client The client that sent the request.
 @param container The container the client requested.
 
 @see WABlobContainer
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobContainer:(WABlobContainer *)container;

/**
 Sent when the client successsfully adds a new blob container.
 
 @param client The client that sent the request.
 @param name The name that was added.
 */
- (void)storageClient:(WACloudStorageClient *)client didAddBlobContainerNamed:(NSString *)name;

/**
 Sent when the client successfully removes an existing blob container.
	
 @param client The client that sent the request.
 @param container The container that was deleted.
 
 @see WABlobContainer
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteBlobContainer:(WABlobContainer *)container;

/**
 Sent when the client successfully removes an existing blob container.
 
 @param client The client that sent the request.
 @param name The name of the container that was deleted.
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteBlobContainerNamed:(NSString *)name;

/**
 Sent when the client successfully returns blobs from an existing container.
	
 @param client The client that sent the request.
 @param blobs The array of WABlob objects returned from the request.
 @param container The WABlobContainer object for the blobs.
 
 @see WABlob
 @see WABlobContainer
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobs:(NSArray *)blobs inContainer:(WABlobContainer *)container;

/**
 Sent when the client successfully returns blobs from an existing container.
	
 @param client The client that sent the request.
 @param blobs The array of WABlob objects returned from the request.
 @param container The WABlobContainer object for the blobs.
 @param resultContinuation The result continuation that contains the marker to use for the next request.
 
 @see WABlob
 @see WABlobContainer
 @see WAResultContinuation
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobs:(NSArray *)blobs inContainer:(WABlobContainer *)container withResultContinuation:(WAResultContinuation *)resultContinuation;

/**
 Sent when the client successfully returns blob data for a given blob.
	
 @param client The client that sent the request.
 @param data The data for the blob.
 @param blob The blob for the the data.
 
 @see WABlob
 @see NSData
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobData:(NSData *)data blob:(WABlob *)blob;

/**
 Sent when the client successfully returns blob data for a given URL.
 
 @param client The client that sent the request.
 @param data The data for the blob.
 @param URL The URL for the the data.
 
 @see NSURL
 @see NSData
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchBlobData:(NSData *)data URL:(NSURL *)URL;

/**
 Sent when the client successfully adds a blob to a specified container.
	
 @param client The client that sent the request.
 @param container The container to add the blob.
 @param blobName The name of the blob
 
 @see WABlobContainer
 */
- (void)storageClient:(WACloudStorageClient *)client didAddBlobToContainer:(WABlobContainer *)container blobName:(NSString *)blobName;

/**
 Sent when the client successfully deletes a blob.
	
 @param client The client that sent the request.
 @param blob The blob that was deleted.
 
 @see WABlob
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteBlob:(WABlob *)blob;

///---------------------------------------------------------------------------------------
/// @name Queue Request Completion
///---------------------------------------------------------------------------------------

/**
 Sent when the client successfully returns a list of queues.
 
 @param client The client that sent the request
 @param queues An array of WAQueue objects.
 
 @see WAQueue
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchQueues:(NSArray *)queues;

/**
 Sent when the client successfully returns a list of queues with a result continuation.
	
 @param client The client that sent the request
 @param queues An array of WAQueue objects.
 @param resultContinuation The result continuation that contains the marker to use for the next request.
 
 @see WAQueue
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchQueues:(NSArray *)queues withResultContinuation:(WAResultContinuation *)resultContinuation;

/**
 Sent when the client successfully adds a queue.
 
 @param client The client that sent the request
 @param queueName The name of the queue that was added.
 */
- (void)storageClient:(WACloudStorageClient *)client didAddQueueNamed:(NSString *)queueName;

/**
 Sent when the client successfully removes an existing queue.
	
 @param client The client that sent the request.
 @param queueName The name of the queue that was deleted.
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteQueueNamed:(NSString *)queueName;

/**
 Sent when the client successfully get messages from the specified queue.
	
 @param client The client that sent the request.
 @param queueMessages An array of WAQueue objects.
 
 @see WAQueueMessage
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchQueueMessages:(NSArray *)queueMessages;

/**
 Sent when the client successfully got a single message from the specified queue
	
 @param client The client that sent the request.
 @param queueMessage The message that was fetched.
 
 @see WAQueueMessage
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchQueueMessage:(WAQueueMessage *)queueMessage;

/**
 Sent when the client successfully peeked a single message from the specified queue.
	
 @param client The client that sent the request. 
 @param queueMessage The message that was fetched.
 
 @see WAQueueMessage
 */
- (void)storageClient:(WACloudStorageClient *)client didPeekQueueMessage:(WAQueueMessage *)queueMessage;

/*!  */
/**
 Sent when the client successfully peeked messages from the specified queue.
	
 @param client The client that sent the request.
 @param queueMessages An array of WAQueueMessage objects.
 
 @see WAQueueMessage
 */
- (void)storageClient:(WACloudStorageClient *)client didPeekQueueMessages:(NSArray *)queueMessages;

/**
 Sent when the client successfully delete a message from the specified queue
	
 @param client The client that sent the request.
 @param queueMessage The message that was deleted.
 @param queueName The name of the queue where the message was deleted.
 
 @see WAQueueMessage
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteQueueMessage:(WAQueueMessage *)queueMessage queueName:(NSString *)queueName;

/**
 Sent when the client successfully put a message into the specified queue.
	
 @param client The client that sent the request.
 @param message The message that was added.
 @param queueName The name of the queue that the message was added.
 */
- (void)storageClient:(WACloudStorageClient *)client didAddMessageToQueue:(NSString *)message queueName:(NSString *)queueName;

///---------------------------------------------------------------------------------------
/// @name Table Request Completion
///---------------------------------------------------------------------------------------

/**
 Sent when the client successfully returns a list of tables.
	
 @param client The client that sent the request.
 @param tables An array of NSString objects that are the names of the tables.
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchTables:(NSArray *)tables;

/**
 Sent when the client successfully returns a list of tables with a continuation.
	
 @param client The client that sent the request.
 @param tables An array of NSString objects that are the names of the tables.
 @param resultContinuation The result continuation that contains the marker to use for the next request.
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchTables:(NSArray *)tables withResultContinuation:(WAResultContinuation *)resultContinuation;

/**
 Sent when the client successfully creates a table.
	
 @param client The client that sent the request.
 @param tableName The table name that was created.
 */
- (void)storageClient:(WACloudStorageClient *)client didCreateTableNamed:(NSString *)tableName;

/**
 Sent when the client successfully deletes a specified table.
	
 @param client The client that sent the request.
 @param tableName The table name that was deleted.
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteTableNamed:(NSString *)tableName;

/**
 Sent when the client successfully returns a list of entities from a table.
	
 @param client The client that sent the request.
 @param entities An array of WATableEntity objects.
 @param tableName The name of the table that contains the enties.
 
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchEntities:(NSArray *)entities fromTableNamed:(NSString *)tableName;

/**
 Sent when the client successfully returns a list of entities from a table.
	
 @param client The client that sent the request.
 @param entities An array of WATableEntity objects.
 @param tableName The table name that contains the entities.
 @param resultContinuation The result continuation that contains the marker to use for the next request.
 
 @see WAResultContinuation
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didFetchEntities:(NSArray *)entities fromTableNamed:(NSString *)tableName withResultContinuation:(WAResultContinuation *)resultContinuation;

/**
 Sent when the client successfully inserts an entity into a table.
	
 @param client The client that sent the request.
 @param entity The entity that was inserted.
 
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didInsertEntity:(WATableEntity *)entity;

/**
 Sent when the client successfully updates an entity within a table.
	
 @param client The client that sent the request.
 @param entity The entity that was updated.
 
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didUpdateEntity:(WATableEntity *)entity;

/**
 Sent when the client successfully merges an entity within a table.
	
 @param client The client that sent the request.
 @param entity The entity that was merged.
 
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didMergeEntity:(WATableEntity *)entity;

/**
 Sent when the client successfully deletes an entity from a table.
	
 @param client The client that sent the request.
 @param entity The entity that was deleted.
 
 @see WATableEntity
 */
- (void)storageClient:(WACloudStorageClient *)client didDeleteEntity:(WATableEntity *)entity;

@end
