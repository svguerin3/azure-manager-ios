//
//  AppDelegate.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "AppDelegate.h"

#import "MainMenuVC.h"
#import "WAConfiguration.h"
#import "WACloudStorageClient.h"
#import "WACloudAccessToken.h"
#import "WACloudAccessControlClient.h"
#import "WAAuthenticationCredential.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize rootVC = _rootVC;
@synthesize authenticationCredential = _authenticationCredential;
@synthesize use_proxy;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    WAConfiguration *config = [WAConfiguration sharedConfiguration];	
	if(!config) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Configuration Error" 
															message:@"You must update the ToolkitConfig section in the application's info.plist file before running the first time."
														   delegate:self 
												  cancelButtonTitle:@"Close" 
												  otherButtonTitles:nil];
		[alertView show];		
		return YES;
	}
	
	if(config.connectionType != WAConnectDirect) {
		[WACloudStorageClient ignoreSSLErrorFor:config.proxyNamespace];
	}
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.rootVC = [[MainMenuVC alloc] initWithNibName:@"MainMenu_iPhone" bundle:nil]; 
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.rootVC = [[MainMenuVC alloc] initWithNibName:@"MainMenu_iPad" bundle:nil]; 
    }
    
	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.navigationController = nav;
	self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    [self initCredentials];
    
    return YES;
}

- (void) initCredentials {
    WAConfiguration *config = [WAConfiguration sharedConfiguration];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.authenticationCredential = [WAAuthenticationCredential credentialWithAzureServiceAccount:config.accountName 
                                                                                               accessKey:config.accessKey];
}

+ (void)bindAccessToken
{
	WAConfiguration* config = [WAConfiguration sharedConfiguration];
    
	if(config.connectionType != WAConnectProxyACS) {
		return;
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *proxyURL = [config proxyURL];
	WACloudAccessToken *sharedToken = [WACloudAccessControlClient sharedToken];

    appDelegate.authenticationCredential = [WAAuthenticationCredential authenticateCredentialWithProxyURL:[NSURL URLWithString:proxyURL] accessToken:sharedToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
