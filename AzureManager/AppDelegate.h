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

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	NSString *dataFilePathToAccountsList;
    NSMutableArray *accountsList;
    NSMutableArray *queriesList;
}

- (void) saveAndEncodeAppData;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) AccountSelectionVC *rootVC;
@property (assign) BOOL use_proxy;

// storage data
@property (nonatomic, retain) NSMutableArray *accountsList;
@property (nonatomic, retain) NSMutableArray *queriesList;
@property (nonatomic, copy) NSString *dataFilePathToAccountsList;
@property (nonatomic, copy) NSString *dataFilePathToQueriesList;

@end
