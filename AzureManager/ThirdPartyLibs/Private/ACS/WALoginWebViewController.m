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

#import "WALoginWebViewController.h"
#import "WACloudAccessControlHomeRealm.h"
#import "WACloudAccessControlClient.h"
#import "NSString+URLEncode.h"
#import "Logging.h"
#import "WACloudAccessToken.h"

const NSString* ScriptNotify = @"<script type=\"text/javascript\">window.external = { 'Notify': function(s) { document.location = 'acs://settoken?token=' + s; }, 'notify': function(s) { document.location = 'acs://settoken?token=' + s; } };</script>";

@interface WACloudAccessToken (Private)

- (id)initWithDictionary:(NSDictionary *)dictionary fromRealm:(WACloudAccessControlHomeRealm *)realm;

@end

@interface WACloudAccessControlClient (Private)

+ (void)setToken:(WACloudAccessToken *)token;

@end

@implementation WALoginWebViewController

- (id)initWithHomeRealm:(WACloudAccessControlHomeRealm *)realm allowsClose:(BOOL)allowsClose withCompletionHandler:(void (^)(WACloudAccessToken *token))block
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        _realm = [realm retain];
		_block = [block retain];
		_allowsClose = allowsClose;
    }
    return self;
}

- (void)dealloc
{
    [_realm release];
    [_data release];
    [_url release];
    [_block release];
    //[_webView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showProgress
{
	UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
	[view startAnimating];
	[view release];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.title = _realm.name;

    // create our web view
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
    self.view = _webView;
    [_webView release];

    // navigate to the login url
    NSURL *url = [NSURL URLWithString:_realm.loginUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
	
	[self showProgress];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIWebViewDelegate

- (NSDictionary*)parsePairs:(NSString*)urlStr
{
	NSRange r = [urlStr rangeOfString:@"="];
	if(r.length == 0)
	{
		return nil;
	}
	
	NSString *token = [[urlStr substringFromIndex:r.location + 1] URLDecode];
	NSCharacterSet *objectMarkers = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
	token = [token stringByTrimmingCharactersInSet:objectMarkers];
	
	NSError *regexError;
	NSMutableDictionary *pairs = [NSMutableDictionary dictionaryWithCapacity:10];
	
	// parse name-value pairs with string values
	//
	NSRegularExpression *nameValuePair;
	nameValuePair = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]*)\":\"([^\"]*)\""
															  options:0 
																error:&regexError];
	NSArray *matches = [nameValuePair matchesInString:token 
											  options:0 
												range:NSMakeRange(0, token.length)];

	for (NSTextCheckingResult *result in matches) {
		for (int n = 1; n < [result numberOfRanges]; n += 2) {
			NSRange r = [result rangeAtIndex:n];
			if (r.length > 0) {
				NSString *name = [token substringWithRange:r];
				
				r = [result rangeAtIndex:n + 1];
				if (r.length > 0) {
					NSString* value = [token substringWithRange:r];
					
					[pairs setObject:value forKey:name];
				}
			}
		}
	}
	
	// parse name-value pairs with numeric values
	//
	nameValuePair = [NSRegularExpression regularExpressionWithPattern:@"\"([^\"]*)\":([0-9]*)"
															  options:0 
																error:&regexError];
	matches = [nameValuePair matchesInString:token options:0 range:NSMakeRange(0, token.length)];
	
	for (NSTextCheckingResult *result in matches) {
		for (int n = 1; n < [result numberOfRanges]; n += 2){
			NSRange r = [result rangeAtIndex:n];
			if (r.length > 0) {
				NSString* name = [token substringWithRange:r];
				
				r = [result rangeAtIndex:n + 1];
				if (r.length > 0) {
					NSString* value = [token substringWithRange:r];
					NSNumber* number = [NSNumber numberWithInt:[value intValue]];
					
					[pairs setObject:number forKey:name];
				}
			}
		}
	}
	
	return pairs;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_url) {
		/* make the call re-entrant when we re-load the content ourselves */
        if ([_url isEqual:[request URL]]) {
            return YES;
        }
        
        [_url release];
    }
    
    _url = [[request URL] retain];
    NSString *scheme = [_url scheme];
    
    if ([scheme isEqualToString:@"acs"]) {
		NSDictionary *pairs = [self parsePairs:[_url absoluteString]];
		if (pairs) {            
            WACloudAccessToken *accessToken = [[WACloudAccessToken alloc] initWithDictionary:pairs fromRealm:_realm];
            
			WA_BEGIN_LOGGING_CUSTOM(WALoggingACS)
                NSLog(@"Setting access token");
			WA_END_LOGGING

			[_block retain];
            [self dismissModalViewControllerAnimated:YES];
			
            _block(accessToken);
			[_block release];
			[accessToken release];
        }

        return NO;
    }
    
    [NSURLConnection connectionWithRequest:request delegate:self];
	[self showProgress];
    
    return NO;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(_data) {
        [_data release];
        _data = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_data) {
        _data = [data mutableCopy];
    } else {
        [_data appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_data) {
        NSString *content = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        
        [_data release];
        _data = nil;

        [_webView loadHTMLString:[ScriptNotify stringByAppendingString:content] baseURL:_url];
		[content release];
		
		self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark -

@end
