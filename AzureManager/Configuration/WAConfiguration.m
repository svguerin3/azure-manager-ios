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

#import "WAConfiguration.h"

@implementation WAConfiguration


+ (WAConfiguration*)sharedConfiguration
{
	static dispatch_once_t once;
    static WAConfiguration *sharedFoo;
    dispatch_once(&once, ^ { sharedFoo = [self new]; });
    return sharedFoo;
}

- (id)init
{
	if(!(self = [super init])) {
		return nil;
	}
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *values = [[bundle infoDictionary] objectForKey:@"ToolkitConfig"];
	if(!values) {
		return nil;
	}
	
	NSString *type = [values objectForKey:@"ConnectionType"];
	if(!values) {
		return nil;
	}

	values = [values objectForKey:type];
	if (!values || !values.count) {
		return nil;
	}
	
	if ([type isEqualToString:@"Direct"]) {
		_type = WAConnectDirect;
	} else if([type isEqualToString:@"CloudReadySimple"]) {
		_type = WAConnectProxyMembership;
	} else if([type isEqualToString:@"CloudReadyACS"]) {
		_type = WAConnectProxyACS;
	}
	
	for (NSString *key in [values allKeys]) {
		NSString *value = [values objectForKey:key];
		if(!value || !value.length || [value hasPrefix:@"{"]) {
			return nil;
		}
	}
	
	_values = values;
	
	return self;
}


- (WAConnectionType) connectionType
{
	return _type;
}

- (NSString *)accountName
{
	return [_values objectForKey:@"AccountName"];
}

- (NSString *)accessKey
{
	return [_values objectForKey:@"DirectAccessKey"];
}

- (NSString *)ACSNamespace
{
	return [_values objectForKey:@"ACSNamespace"];
}

- (NSString *)ACSRealm
{
	return [_values objectForKey:@"ACSRealm"];
}

- (NSString *)proxyNamespace
{
	return [_values objectForKey:@"ProxyService"];
}

- (NSString *)proxyURL
{
	NSURL *absURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.cloudapp.net/", self.proxyNamespace]];	
	return [absURL absoluteString];
}

- (NSString *)proxyURL:(NSString*)path
{
	NSURL *absURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.cloudapp.net/", self.proxyNamespace]];
	NSURL *pathURL = [NSURL URLWithString:path relativeToURL:absURL];
	
	return [pathURL absoluteString];
}

@end
