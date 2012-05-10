//
//  WAQuery.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "WAQuery.h"

@implementation WAQuery

@synthesize listOfKeys;
@synthesize queryName;
@synthesize allKeysSelected;
@synthesize filterStr;

- (id) initWithCoder:(NSCoder *)coder {
	listOfKeys = [coder decodeObjectForKey:@"listOfKeys"];
	queryName = [coder decodeObjectForKey:@"queryName"];
    allKeysSelected = [coder decodeObjectForKey:@"allKeysSelected"];
	filterStr = [coder decodeObjectForKey:@"filterStr"];
    
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:listOfKeys forKey:@"listOfKeys"];
	[encoder encodeObject:queryName forKey:@"queryName"];
    [encoder encodeObject:allKeysSelected forKey:@"allKeysSelected"];
    [encoder encodeObject:filterStr forKey:@"allKeysSelected"];
}

@end
