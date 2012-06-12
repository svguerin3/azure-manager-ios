//
//  WAConfig.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAAuthenticationCredential;
@class WAAuthManageCred;

@interface WAConfig : NSObject

+ (WAConfig *)sharedConfiguration;
- (void) initCredentialsWithAccountName:(NSString *)accountName withAccessKey:(NSString *)accessKey;
  
// session vars
@property (nonatomic, retain) WAAuthenticationCredential *storageAuthCred;
@property (nonatomic, retain) WAAuthManageCred *manageAuthCred;
@property int querySelectedIndex;

@end
