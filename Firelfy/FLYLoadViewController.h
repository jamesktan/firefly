//
//  FLYLoadViewController.h
//  Firelfy
//
//  Created by James Tan on 5/2/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYDeviceManager.h"

@interface FLYLoadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    FLYDeviceManager *DEVICE_MANAGER;
    NSInteger selectedIndex;
}

- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *existingCaseTable;
@property (strong, nonatomic) NSArray * fileList;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
