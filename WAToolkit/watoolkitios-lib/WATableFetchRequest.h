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

@class WAResultContinuation;

/**
 A class that represents a Windows Azure Storage fetch request.
 
 The request is used with the WACloudStorageClient when working with tables.
 
 @see WATableFetchRequest
 */
@interface WATableFetchRequest : NSObject
{
@private
    NSString *_tableName;
    NSString *_partitionKey;
    NSString *_rowKey;
    NSString *_filter;
    NSInteger _topRows;
    WAResultContinuation *_resultContinuation;
}

/**
 The table name.
 */
@property (readonly) NSString *tableName;

/**
 The partition key.
 */
@property (copy) NSString *partitionKey;

/**
 The row key.
 */
@property (copy) NSString *rowKey;

/**
 The filter to use in the table fetch request.
 */
@property (copy) NSString *filter;

/**
 The number of rows to limit with the tech.
 */
@property (assign) NSInteger topRows;

/**
 The continuation to use in the fetch request.
 */
@property (nonatomic, retain) WAResultContinuation *resultContinuation;

/**
 Create a new WATableFetchRequest with a table name.
 
 @param tableName The table name for the fetch request.
 
 @returns The newly initialized WATableFetchRequest object.
 */
+ (WATableFetchRequest *)fetchRequestForTable:(NSString *)tableName;

/**
 Create a new WATableFetchRequest with a table name, predicate, and error.
 
 @param tableName The table name for the fetch request.
 @param predicate The predicate for the fetch request.
 @param error An NSError object that will be populated if the predicate is not valid.
 
 @returns The newly initialized WATableFetchRequest object.
 
 @see NSPredicate
 */
+ (WATableFetchRequest *)fetchRequestForTable:(NSString *)tableName predicate:(NSPredicate *)predicate error:(NSError **)error;

@end
