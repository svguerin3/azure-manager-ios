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
 Represents the type of continuation in a WAResultContinuation.
 
 @see WAResultContinuation
 */
typedef enum {
    WAContinuationNone = 0,
    WAContinuationBlob = 1,
    WAContinuationQueue = 2,
    WAContinuationContainer = 3,
    WAContinuationTable = 4,
    WAContinuationEntity = 5
} WAContinuationType;

/**
 A class that represents continuation token information used with paging Windows Azure data.
 */
@interface WAResultContinuation : NSObject {
@private
    NSString *_nextParitionKey;
    NSString *_nextRowKey;
    NSString *_nextTableKey;
    NSString *_nextMarker;
    WAContinuationType _continuationType;
}

/** 
 The next partition key to be returned in a subsequent query against the table. 
 */
@property (nonatomic, readonly) NSString *nextPartitionKey;

/**
 The next row key to be returned in a subsequent query against the table.
 */
@property (nonatomic, readonly) NSString *nextRowKey;

/**
 If the list of tables returned is not complete, the name of the next table in the list.
 */
@property (nonatomic, readonly) NSString *nextTableKey;

/**
 A value that identifies the portion of the list to be returned with the next list operation if the list returned was not complete. The marker value may then be used in a subsequent call to request the next set of list items.
 */
@property (nonatomic, readonly) NSString *nextMarker;

/**
 The type of continuation token.
 */
@property (nonatomic, readonly) WAContinuationType continuationType;

/**
 Determines if there is a continuation. The default is WAContinuationNone.
 
 @see WAContinuationType
 */
@property (nonatomic, readonly) BOOL hasContinuation;

/**
 Initializes a newly created WAResultContinuation with a parition key and row key.
 The continuationType will be WAContinuationEntity.
 
 @param nextParitionKey The next partition key.
 @param nextRowKey The next row key.
 
 @returns The newly initialized WAResultContinuation object.
 */
- (id)initWithNextParitionKey:(NSString *)nextParitionKey nextRowKey:(NSString *)nextRowKey;

/**
 Initializes a newly created WAResultContinuation with a table key.
 The continuationType will be WAContinuationTable.
 
 @param nextTableKey The next table key.
 
 @returns The newly initialized WAResultContinuation object.
 */
- (id)initWithNextTableKey:(NSString *)nextTableKey;

/**
 Initializes a newly created WAResultContinuation with a marker and continuation type.
 
 @param marker The marker of the next item in the list operation.
 @param continuationType The type of list operation.
 
 @returns The newly initialized WAResultContinuation object.
 
 @see WAContinuationType
 */
- (id)initWithContainerMarker:(NSString *)marker continuationType:(WAContinuationType)continuationType;

@end
