//
//  UIViewController+UIElements.m
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import "UIViewController+UIElements.h"
#import "MBProgressHUD.h"

@implementation UIViewController (UIElements)

- (void) showLoader:(UIView *)theView {
    [MBProgressHUD showHUDAddedTo:theView animated:YES];
}

- (void) hideLoader:(UIView *)theView {
    [MBProgressHUD hideHUDForView:theView animated:YES];
}

@end
