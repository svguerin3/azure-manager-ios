//
//  AccountData.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "AccountData.h"

@implementation AccountData

@synthesize accountName;
@synthesize accessKey;
@synthesize subscriptionID;

- (id) initWithCoder:(NSCoder *)coder {
	accountName = [coder decodeObjectForKey:@"accountName"];
	accessKey = [coder decodeObjectForKey:@"accessKey"];
	subscriptionID = [coder decodeObjectForKey:@"subscriptionID"];
    
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:accountName forKey:@"accountName"];
	[encoder encodeObject:accessKey forKey:@"accessKey"];
    [encoder encodeObject:subscriptionID forKey:@"subscriptionID"];
}

@end
