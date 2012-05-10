//
//  AppDelegate.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "AppDelegate.h"

#import "AccountSelectionVC.h"
#import "WAConfig.h"
#import "WACloudStorageClient.h"
#import "WACloudAccessToken.h"
#import "WACloudAccessControlClient.h"
#import "WAAuthenticationCredential.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize rootVC = _rootVC;
@synthesize use_proxy;

@synthesize accountsList;
@synthesize queriesList;

@synthesize dataFilePathToAccountsList;
@synthesize dataFilePathToQueriesList;

- (id) init {   
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // INIT ACCOUNTS INFO FROM STORAGE
	NSString *pathToAccountsList = [documentsDirectory stringByAppendingPathComponent:@"accountslist.dat"];
	[self setDataFilePathToAccountsList:pathToAccountsList];
    
    // check if .dat file exists in docs folder
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePathToAccountsList]) {
        NSLog(@"account data exists");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArr;
		
		theData = [NSData dataWithContentsOfFile:dataFilePathToAccountsList];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArr = [decoder decodeObjectForKey:@"accountslist"];
		accountsList = tempArr;
		[decoder finishDecoding];
	} else { // didn't find it, so this is probably the first time the user is using the app
        NSLog(@"account data does NOT exist, creating new");
		accountsList = [[NSMutableArray alloc] init];
	}
    
    // INIT QUERIES INFO FROM STORAGE
    NSString *pathToQueriesList = [documentsDirectory stringByAppendingPathComponent:@"querieslist.dat"];
	[self setDataFilePathToQueriesList:pathToQueriesList];
    
    // check if .dat file exists in docs folder
	if([fileManager fileExistsAtPath:dataFilePathToQueriesList]) {
        NSLog(@"queries data exists");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArr;
		
		theData = [NSData dataWithContentsOfFile:dataFilePathToQueriesList];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArr = [decoder decodeObjectForKey:@"querieslist"];
		queriesList = tempArr;
		[decoder finishDecoding];
	} else { // didn't find it, so this is probably the first time the user is using the app
        NSLog(@"queries data does NOT exist, creating new");
		queriesList = [[NSMutableArray alloc] init];
	}
    
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.rootVC = [[AccountSelectionVC alloc] initWithNibName:@"AccountSelection_iPhone" bundle:nil]; 
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.rootVC = [[AccountSelectionVC alloc] initWithNibName:@"AccountSelection_iPad" bundle:nil]; 
    }
    
	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.navigationController = nav;
	self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
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
    
    [self saveAndEncodeAppData];
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
    [self saveAndEncodeAppData];
}

- (void) saveAndEncodeAppData {
    NSMutableData *theDataAccountsList = [NSMutableData data];
	NSKeyedArchiver *encoderAccountsList = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theDataAccountsList];
	[encoderAccountsList encodeObject:accountsList forKey:@"accountslist"];
	[encoderAccountsList finishEncoding]; 
	[theDataAccountsList writeToFile:dataFilePathToAccountsList atomically:YES];
    
    NSLog(@"saving queriesListCount: %i", [queriesList count]);
    NSMutableData *theDataQueriesList = [NSMutableData data];
	NSKeyedArchiver *encoderQueriesList = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theDataQueriesList];
	[encoderQueriesList encodeObject:queriesList forKey:@"querieslist"];
	[encoderQueriesList finishEncoding]; 
	[theDataQueriesList writeToFile:dataFilePathToQueriesList atomically:YES];
}

@end
