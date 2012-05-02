//
//  BlobImageViewVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "BlobImageViewVC.h"
#import "WABlob.h"
#import "AppDelegate.h"

@interface BlobImageViewVC ()

@end

@implementation BlobImageViewVC

@synthesize blobImgView = _blobImgView;
@synthesize currBlob = _currBlob;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    storageClient = nil;
    
    [self showLoader:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (storageClient) {
        storageClient.delegate = nil;
	}
    
	storageClient = [WACloudStorageClient storageClientWithCredential:appDelegate.authenticationCredential];
    
    NSString *contentType = [self.currBlob.properties objectForKey:WABlobPropertyKeyContentType];
    if ([contentType hasPrefix:@"image"]) {
        self.title = @"Blob Image";
		[storageClient fetchBlobData:self.currBlob withCompletionHandler:^(NSData *imgData, NSError *error) {
			UIImage *blobImage = [UIImage imageWithData:imgData];
			self.blobImgView.image = blobImage;
            [self hideLoader:self.view];
		}];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.blobImgView = nil;
    self.currBlob = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
