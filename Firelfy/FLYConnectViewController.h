//
//  FLYConnectViewController.h
//  Firelfy
//
//  Created by James Tan on 4/10/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYConnectionManager.h"

#import <MBProgressHUD.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "FLYUtility.h"
@interface FLYConnectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSArray *devices;
    NSInteger connectedDevices;
    
    FLYConnectionManager *ConnectionManager;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UITableView *deviceTable;

- (IBAction)goBack:(id)sender;
- (IBAction)scanDevices:(id)sender;
- (IBAction)goChart:(id)sender;

@end
