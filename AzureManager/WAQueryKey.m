//
//  WAQueryKey.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "WAQueryKey.h"

@implementation WAQueryKey

@synthesize keyName;
@synthesize keySelected;

- (id) initWithCoder:(NSCoder *)coder {
	keyName = [coder decodeObjectForKey:@"keyName"];
	keySelected = [coder decodeObjectForKey:@"keySelected"];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:keyName forKey:@"keyName"];
	[encoder encodeObject:keySelected forKey:@"keySelected"];
}

@end
