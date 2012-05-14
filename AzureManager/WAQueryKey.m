//
//  WAQueryKey.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/10/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "WAQueryKey.h"

@implementation WAQueryKey

@synthesize keyText;
@synthesize keySelected;

- (id) initWithCoder:(NSCoder *)coder {
	keyText = [coder decodeObjectForKey:@"keyText"];
	keySelected = [coder decodeObjectForKey:@"keySelected"];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:keyText forKey:@"keyText"];
	[encoder encodeObject:keySelected forKey:@"keySelected"];
}

@end
