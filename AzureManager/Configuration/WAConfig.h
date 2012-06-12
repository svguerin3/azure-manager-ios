//
//  WAConfig.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAAuthenticationCredential;

@interface WAConfig : NSObject

+ (WAConfig *)sharedConfiguration;
- (void) initStorageCredentialsWithAccountName:(NSString *)accountName withAccessKey:(NSString *)accessKey;
  
// session vars
@property (nonatomic, retain) WAAuthenticationCredential *storageAuthCred;
@property int querySelectedIndex;

@end
