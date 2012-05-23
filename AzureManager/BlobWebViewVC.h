//
//  BlobWebViewVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/23/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WABlob;

@interface BlobWebViewVC : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet WABlob *currBlob;

@end
