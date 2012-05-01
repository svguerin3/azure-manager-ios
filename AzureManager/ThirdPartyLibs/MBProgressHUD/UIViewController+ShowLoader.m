//
//  UIViewController+ShowLoader.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import "UIViewController+ShowLoader.h"
#import "MBProgressHUD.h"

@implementation UIViewController (ShowLoader)

- (void) showLoader:(UIView *)theView {
    [MBProgressHUD showHUDAddedTo:theView animated:YES];
}

- (void) hideLoader:(UIView *)theView {
    [MBProgressHUD hideHUDForView:theView animated:YES];
}

@end
