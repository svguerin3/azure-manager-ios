//
//  UIViewController+UIElements.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (UIElements)

- (void) showLoader:(UIView *)theView;
- (void) hideLoader:(UIView *)theView;

@end