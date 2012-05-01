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

#import "WALoginRealmPickerTableViewController.h"
#import "WACloudAccessControlHomeRealm.h"
#import "WALoginWebViewController.h"
#import "Logging.h"
#import "WACloudAccessToken.h"

@implementation WALoginRealmPickerTableViewController

- (id)initWithRealms:(NSArray*)realms allowsClose:(BOOL)allowsClose withCompletionHandler:(void (^)(WACloudAccessToken* token))block
{
    if ((self = [super initWithStyle:UITableViewStylePlain])) 
    {
        _realms = [realms retain];
		_block = [block retain];
		_allowsClose = allowsClose;
        
        self.title = @"Pick Login Method";
    }
    return self;
}

- (void)dealloc
{
    [_realms release];
	[_block release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)cancel:(id)sender
{
	[_block retain];
    [self dismissModalViewControllerAnimated:YES];
	_block(nil);
	[_block release];
}

-(BOOL)isModal 
{
    return 
		// first check if parent view self is the modalviewcontroller of the parentviewcontroller
		(self.parentViewController && self.parentViewController.modalViewController == self) || 
		//or if it has a navigation controller, check if its parent modal view controller is the navigation controller
		( self.navigationController && self.navigationController.parentViewController && self.navigationController.parentViewController.modalViewController == self.navigationController);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	if([self isModal] && _allowsClose)
	{
		UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
		self.navigationItem.leftBarButtonItem = item;
		[item release];
	}

	UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Pick" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:backButton];
	[backButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _realms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    WACloudAccessControlHomeRealm* realm = [_realms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = realm.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WACloudAccessControlHomeRealm* realm = [_realms objectAtIndex:indexPath.row];
	
	WA_BEGIN_LOGGING_CUSTOM(WALoggingACS)
        NSLog(@"Picked identity provider: %@", realm.name);
	WA_END_LOGGING

    WALoginWebViewController* webController = [[WALoginWebViewController alloc] initWithHomeRealm:realm
																					  allowsClose:_allowsClose
																			withCompletionHandler:_block];
    [self.navigationController pushViewController:webController animated:YES];
    [webController release];
}

@end
