//
//  WAConfig.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/3/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAAuthenticationCredential;

@interface WAConfig : NSObject

+ (WAConfig *)sharedConfiguration;
- (void) initCredentialsWithAccountName:(NSString *)accountName withAccessKey:(NSString *)accessKey;
    
@property (nonatomic, retain) WAAuthenticationCredential *authenticationCredential;

@end
