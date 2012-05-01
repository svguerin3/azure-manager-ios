//
//  UIViewController+ShowLoader.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/1/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (ShowLoader)

- (void) showLoader:(UIView *)theView;
- (void) hideLoader:(UIView *)theView;

@end