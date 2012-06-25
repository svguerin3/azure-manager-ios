//
//  MonitoringSettingsVC.h
//  AzureManager
//
//  Created by Vincent Guerin on 6/25/12.
//  Copyright (c) 2012 Vurgood Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitoringSettingsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UITextField *loggingRetentionDaysField;
    UITextField *metricsRetentionDaysField;
    
    UISwitch *mySwitchDelete, *mySwitchRead, *mySwitchWrite, *mySwitchLoggingRetentionEnabled;
    UISwitch *mySwitchMetricsEnabled, *mySwitchIncludeAPIs, *mySwitchMetricsRetentionEnabled;
}

- (void) shiftView:(int)yCoord;
- (void) lowerKeyboard;
- (NSString *) removeBadCharacters:(NSString *)myStr;
- (NSString *) getPayloadString;
- (void) refreshEnabledFields;

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSString *monitoringSelTypeStr;

@end
