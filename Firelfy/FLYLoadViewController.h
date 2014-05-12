//
//  FLYLoadViewController.h
//  Firelfy
//
//  Created by James Tan on 5/2/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYDeviceManager.h"
#import "FLYUtility.h"

@interface FLYLoadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    FLYDeviceManager *DEVICE_MANAGER;
    NSInteger selectedIndex;
    NSMutableArray * selectedFiles;
}

- (IBAction)goBack:(id)sender;
- (IBAction)loadChart:(id)sender;
- (IBAction)deleteSelected:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *existingCaseTable;
@property (strong, nonatomic) NSArray * fileList;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end
