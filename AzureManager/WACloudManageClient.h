//
//  WACloudManageClient.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/12/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WACloudManageClientDelegate;

/**
 The cloud management client is used to invoke operations on, and return data from, Windows Azure Management APIs. 
 */
@interface WACloudManageClient : NSObject {
@private
	WAAuthenticationCredential* _credential;
}

///---------------------------------------------------------------------------------------
/// @name Setting the Delegate
///---------------------------------------------------------------------------------------

/**
 The delegate is sent messages when content is loaded or errors occur from Windows Azure storage.
 */
@property (assign) id<WACloudManageClientDelegate> delegate;

@end
