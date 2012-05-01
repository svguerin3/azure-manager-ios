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
 A class that represents an entity ina a Windows Azure table.
 */
@interface WATableEntity : NSObject {
@private
    NSString *_tableName;
    NSString *_partitionKey;
    NSString *_rowKey;
    NSDate *_timeStamp;
    NSMutableDictionary *_dictionary;
}

/**
 The name of the table where this entity is located.
 */
@property (readonly) NSString* tableName;

/**
 The partition key of a table entity.
 The concatenation of the partition key and row key form the primary key for an entity, and so must be unique within the table.
 */
@property (copy) NSString* partitionKey;

/**
 The row key of a table entity.
 The concatenation of the partition key and row key form the primary key for an entity, and so must be unique within the table.
 */
@property (copy) NSString* rowKey;

/**
 The timestamp for this entity.
 */
@property (readonly) NSDate* timeStamp;

/**
 Returns a new array containing the entity’s keys.
 
 @returns A new array containing the entity’s keys, or an empty array if the entity has no entries.
 */
- (NSArray*)keys;

/**
 Returns the value associated with a given key.
 
 @param key The key for which to return the corresponding value.
 
 @returns The value associated with key, or nil if no value is associated with key.
 */
- (id)objectForKey:(NSString *)key;

/**
 Adds a given key-value pair to the entity.
 
 @param value The value for key.
 @param key The key for value.
 */
- (void)setObject:(id)value forKey:(NSString*)key;

/**
 Creates a new entity given the name of an existing table.
 
 @param table The name of the table for this entity.
 
 @returns A new WATableEntity object.
 */
+ (WATableEntity *)createEntityForTable:(NSString*)table;

@end
