//
//  BlobWebViewVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/23/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "BlobWebViewVC.h"
#import "WABlob.h"

@interface BlobWebViewVC ()

@end

@implementation BlobWebViewVC

@synthesize webView = _webView;
@synthesize currBlob = _currBlob;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Blob Viewer";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:[self.currBlob.URL absoluteString]];
	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:requestObj];
    self.webView.scalesPageToFit = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.webView = nil;
    self.currBlob = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
