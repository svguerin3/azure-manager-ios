//
//  EntityDetailVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 5/8/12.
//  Copyright (c) 2012 Neudesic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WATableEntity;

@interface EntityDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@private
    BOOL objViewSelected;
}

- (IBAction)viewTypeFilterBtnPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) IBOutlet UILabel *entityKeyInfoLbl;
@property (nonatomic, retain) WATableEntity *currEntity;

@end
