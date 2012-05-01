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

#import "WALoginProgressViewController.h"
#import "WALoginRealmPickerTableViewController.h"
#import "WACloudAccessControlClient.h"
#import "WALoginWebViewController.h"
#import "WACloudAccessControlHomeRealm.h"
#import "WACloudURLRequest.h"
#import "WACloudAccessToken.h"
#import "Logging.h"

@interface WACloudAccessControlHomeRealm (Private)

- (id)initWithPairs:(NSDictionary*)pairs emailSuffixes:(NSArray*)emailSuffixes;

@end

@implementation WALoginProgressViewController

- (id)initWithURL:(NSURL*)serviceURL allowsClose:(BOOL)allowsClose withCompletionHandler:(void (^)(WACloudAccessToken* token))block
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
    {
        _serviceURL = [serviceURL retain];
		_block = [block copy];
    }
    return self;
}

- (void)dealloc
{
    [_serviceURL release];
	[_block release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)getIdentityProvidersWithBlock:(void (^)(NSArray *, NSError *))block
{
    WACloudURLRequest *request = [WACloudURLRequest requestWithURL:_serviceURL];
    
	WA_BEGIN_LOGGING_CUSTOM(WALoggingACS)
        NSLog(@"Fetching identity providers");
	WA_END_LOGGING

    [request fetchDataWithCompletionHandler:^(WACloudURLRequest *request, NSData *data, NSError *error)  {
        if(error) {
            block(nil, error);
            return;
        }
		 
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];
		 
        NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        json = [json stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
		 
        NSArray *providers = [json componentsSeparatedByString:@"},{"];
        NSCharacterSet *objectMarkers = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
        NSTextCheckingResult *result;
        NSError *regexError = nil;
        NSRegularExpression *nameValuePair = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]*)\":\"([^\"]*)\""
																						options:0 
																						  error:&regexError];
        NSRegularExpression *emailSuffixes = [NSRegularExpression regularExpressionWithPattern:@"\"EmailAddressSuffixes\":\\[(\"([^\"]*)\",?)*\\]"
																						options:0 
																						  error:&regexError];
        for(NSString *provider in providers) {
            provider = [provider stringByTrimmingCharactersInSet:objectMarkers];
			 
            NSArray *matches = [nameValuePair matchesInString:provider options:0 range:NSMakeRange(0, provider.length)];
            NSMutableDictionary *pairs = [NSMutableDictionary dictionaryWithCapacity:10];
			 
            for (result in matches) {
                for(int n = 1; n < [result numberOfRanges]; n += 2) {
                    NSRange r = [result rangeAtIndex:n];
                    if (r.length > 0) {
                        NSString *name = [provider substringWithRange:r];
						 
                        r = [result rangeAtIndex:n + 1];
                        if (r.length > 0) {
                            NSString *value = [provider substringWithRange:r];
							 
                            [pairs setObject:value forKey:name];
                        }
                    }
                }
            }
			 
            result = [emailSuffixes firstMatchInString:provider options:0 range:NSMakeRange(0, provider.length)];
			 
            NSMutableArray *emailAddressSuffixes = [NSMutableArray arrayWithCapacity:10];
            for (int n = 1; n < [result numberOfRanges]; n++) {
                NSRange r = [result rangeAtIndex:n];
                if (r.length > 0) {
                    [emailAddressSuffixes addObject:[provider substringWithRange:r]];
                }
            }
			 
            // mobile URL fixup
            NSString *name = [pairs objectForKey:@"Name"];
            if([name isEqualToString:@"Windows Live™ ID"]) {
                NSString *loginURL = [pairs objectForKey:@"LoginUrl"];
                BOOL hasQuery = [loginURL rangeOfString:@"?"].length > 0;
				 
                loginURL = [NSString stringWithFormat:hasQuery ? @"%@&pcexp=false" : @"%@?pcexp=false",
							 loginURL];
                [pairs setObject:loginURL forKey:@"LoginUrl"];
            }
			 
            WACloudAccessControlHomeRealm* homeRealm = [[WACloudAccessControlHomeRealm alloc] initWithPairs:pairs emailSuffixes:emailAddressSuffixes];
            [results addObject:homeRealm];
            [homeRealm release];
        }
		 
        NSArray *sorted = [results sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WACloudAccessControlHomeRealm *realm1 = obj1;
            WACloudAccessControlHomeRealm *realm2 = obj2;
			 
            return [realm1.name compare:realm2.name];
        }];
		 
        WA_BEGIN_LOGGING_CUSTOM(WALoggingACS)
            NSMutableArray *providerNames = [NSMutableArray arrayWithCapacity:sorted.count];
            [sorted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 [providerNames addObject:[obj name]];
            }];
            NSLog(@"Found identity providers: %@", providerNames);
        WA_END_LOGGING
		 
        block(sorted, nil);
    }];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
	[view release];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 140, 25, 25);
    [self.view addSubview:activityView];
    [activityView release];
    
    [activityView startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(135, 140, 320-70, 25)];
    label.text = @"Loading";
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    [label release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getIdentityProvidersWithBlock:^(NSArray *realms, NSError *error) {
        if (error) {
            UIAlertView *alert;
			 
            alert = [[UIAlertView alloc] initWithTitle:@"Login" 
                                               message:[error localizedDescription]
                                              delegate:nil 
                                     cancelButtonTitle:@"OK" 
                                     otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
         
        [[self retain] autorelease];
         
        UINavigationController* navController = self.navigationController;
        UIViewController* controller;
		 
        // don't ask the user to pick from a list of one realm!
        if (realms.count == 1) {
            WACloudAccessControlHomeRealm *realm = [realms objectAtIndex:0];
            controller = [[WALoginWebViewController alloc] initWithHomeRealm:realm
                                                                 allowsClose:_allowsClose
                                                       withCompletionHandler:_block];
        } else {
            controller = [[WALoginRealmPickerTableViewController alloc] initWithRealms:realms 
																		   allowsClose:_allowsClose
																 withCompletionHandler:_block];
        }
		 
        navController.viewControllers = [NSArray arrayWithObject:controller];
        [controller release];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
