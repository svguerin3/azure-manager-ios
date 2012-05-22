//
//  PropertyDetailVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/8/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WATableEntity;

@interface PropertyDetailVC : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *propKeyLbl;
@property (nonatomic, retain) IBOutlet UITextView *propValTextView;
@property (nonatomic, retain) WATableEntity *currEntity;
@property (nonatomic, copy) NSString *propertyKeyStr;

@end
