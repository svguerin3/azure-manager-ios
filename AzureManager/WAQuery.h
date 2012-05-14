//
//  WAQuery.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAQuery : NSObject

@property (nonatomic, retain) NSMutableArray *listOfKeys;
@property (nonatomic, retain) NSString *queryName;
@property (nonatomic, retain) NSNumber *allKeysSelected;
@property (nonatomic, retain) NSString *filterStr;

@end
