//
//  BlobImageViewVC.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/2/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "BlobImageViewVC.h"
#import "WABlob.h"

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
        self.title = @"Blob Image Viewer";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    [self showLoader:self.view];

    storageClient = [WACloudStorageClient storageClientWithCredential:[WAConfig sharedConfiguration].storageAuthCred];

    [storageClient fetchBlobData:self.currBlob withCompletionHandler:^(NSData *imgData, NSError *error) {
        NSLog(@"imgData length: %i", [imgData length]);
        UIImage *blobImage = [UIImage imageWithData:imgData];
        self.blobImgView.image = blobImage;
            
        if (error) {
            [self showError:error];
        }
        [self hideLoader:self.view];
    }];
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
