//
//  AppDelegate.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountSelectionVC;
@class WAAuthenticationCredential;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void) initCredentials;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) AccountSelectionVC *rootVC;
@property (nonatomic, retain) WAAuthenticationCredential *authenticationCredential;
@property (assign) BOOL use_proxy;

@end
